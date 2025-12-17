import 'package:flutter/material.dart';
import '../../models/pizza_ingredient.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreatePizzaScreen extends StatefulWidget {
  const CreatePizzaScreen({Key? key}) : super(key: key);

  @override
  State<CreatePizzaScreen> createState() => _CreatePizzaScreenState();
}

class _CreatePizzaScreenState extends State<CreatePizzaScreen> {
  PizzaBase? _selectedBase;
  final Set<String> _selectedIngredients = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double _calculateTotalPrice() {
    double total = _selectedBase?.basePrice ?? 0;
    for (var ingredient in _selectedIngredients) {
      final ing = PizzaIngredients.allIngredients.firstWhere(
        (i) => i.name == ingredient,
        orElse: () => const PizzaIngredient(name: '', price: 0),
      );
      total += ing.price;
    }
    return total;
  }

  void _addToCart() {
    if (_selectedBase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleziona una base per la tua pizza'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aggiungi almeno un ingrediente'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final customization = PizzaCustomization(
      base: _selectedBase,
      addedIngredients: _selectedIngredients.toList(),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final cartItem = CartItem(
      menuItemId: const Uuid().v4(),
      name: 'Pizza Personalizzata (${_selectedBase!.name})',
      price: _selectedBase!.basePrice,
      quantity: 1,
      customization: customization,
    );

    cartProvider.addCartItem(cartItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pizza aggiunta al carrello!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea la tua Pizza'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selezione Base
                  Text(
                    'Scegli la Base',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seleziona la base che più ti piace',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: PizzaIngredients.bases.map((base) {
                      final isSelected = _selectedBase == base;
                      return ChoiceChip(
                        label: Text(
                          '${base.name} (${base.basePrice.toStringAsFixed(2)}€)',
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedBase = selected ? base : null;
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        avatar: isSelected
                            ? Icon(Icons.check_circle, size: 20, color: Theme.of(context).primaryColor)
                            : null,
                      );
                    }).toList(),
                  ),

                  const Divider(height: 32),

                  // Selezione Ingredienti
                  Text(
                    'Scegli gli Ingredienti',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seleziona gli ingredienti che vuoi tu',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ingredienti raggruppati per prezzo
                  ...PizzaIngredients.ingredientsByPrice.entries.map((entry) {
                    final price = entry.key;
                    final ingredients = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ingredienti da ${price.toStringAsFixed(2)}€ ognuno',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ingredients.map((ingredient) {
                            final isSelected = _selectedIngredients.contains(ingredient.name);
                            return FilterChip(
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(ingredient.name),
                                  if (ingredient.note != null)
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedIngredients.add(ingredient.name);
                                  } else {
                                    _selectedIngredients.remove(ingredient.name);
                                  }
                                });
                              },
                              avatar: Icon(
                                isSelected ? Icons.check : Icons.add,
                                size: 18,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),

                  // Note sui prodotti surgelati
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '* Alcuni prodotti potrebbero essere surgelati o congelati',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 32),

                  // Note aggiuntive
                  Text(
                    'Commenti Aggiuntivi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Indica eventuali informazioni utili per l\'ordine...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedBase != null) ...[
                      Text(
                        'Base: ${_selectedBase!.basePrice.toStringAsFixed(2)}€',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (_selectedIngredients.isNotEmpty)
                        Text(
                          'Ingredienti: ${(totalPrice - _selectedBase!.basePrice).toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      'Totale: ${totalPrice.toStringAsFixed(2)}€',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Aggiungi al carrello'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
