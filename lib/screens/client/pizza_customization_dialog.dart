import 'package:flutter/material.dart';
import '../../models/menu_item.dart';
import '../../models/pizza_ingredient.dart';

class PizzaCustomizationDialog extends StatefulWidget {
  final MenuItem pizza;

  const PizzaCustomizationDialog({
    Key? key,
    required this.pizza,
  }) : super(key: key);

  @override
  State<PizzaCustomizationDialog> createState() => _PizzaCustomizationDialogState();
}

class _PizzaCustomizationDialogState extends State<PizzaCustomizationDialog> {
  final Set<String> _addedIngredients = {};
  final Set<String> _removedIngredients = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double _calculateExtraPrice() {
    double total = 0;
    for (var ingredient in _addedIngredients) {
      final ing = PizzaIngredients.allIngredients.firstWhere(
        (i) => i.name == ingredient,
        orElse: () => const PizzaIngredient(name: '', price: 0),
      );
      total += ing.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final extraPrice = _calculateExtraPrice();
    final totalPrice = widget.pizza.price + extraPrice;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalizza',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.pizza.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ingredienti originali
                    if (widget.pizza.ingredients.isNotEmpty) ...[
                      Text(
                        'Ingredienti inclusi',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.pizza.ingredients.map((ingredient) {
                          final isRemoved = _removedIngredients.contains(ingredient);
                          return FilterChip(
                            label: Text(ingredient),
                            selected: !isRemoved,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _removedIngredients.remove(ingredient);
                                } else {
                                  _removedIngredients.add(ingredient);
                                }
                              });
                            },
                            avatar: Icon(
                              isRemoved ? Icons.remove_circle : Icons.check_circle,
                              size: 18,
                            ),
                          );
                        }).toList(),
                      ),
                      const Divider(height: 32),
                    ],

                    // Aggiungi ingredienti
                    Text(
                      'Aggiungi ingredienti',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
                          Text(
                            'Ingredienti da ${price.toStringAsFixed(2)}€',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ingredients.map((ingredient) {
                              final isAdded = _addedIngredients.contains(ingredient.name);
                              return FilterChip(
                                label: Text(ingredient.name),
                                selected: isAdded,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _addedIngredients.add(ingredient.name);
                                    } else {
                                      _addedIngredients.remove(ingredient.name);
                                    }
                                  });
                                },
                                avatar: Icon(
                                  isAdded ? Icons.check : Icons.add,
                                  size: 18,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),

                    // Note aggiuntive
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Note aggiuntive',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Aggiungi informazioni utili per l\'ordine...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (extraPrice > 0) ...[
                          Text(
                            'Prezzo base: ${widget.pizza.price.toStringAsFixed(2)}€',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Extra: ${extraPrice.toStringAsFixed(2)}€',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          'Totale: ${totalPrice.toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      final customization = PizzaCustomization(
                        addedIngredients: _addedIngredients.toList(),
                        removedIngredients: _removedIngredients.toList(),
                        notes: _notesController.text.isEmpty ? null : _notesController.text,
                      );
                      Navigator.pop(context, customization);
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Aggiungi al carrello'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
