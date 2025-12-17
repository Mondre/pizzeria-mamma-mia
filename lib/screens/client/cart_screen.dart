import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrello'),
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _showClearCartDialog(context, cartProvider);
              },
              tooltip: 'Svuota carrello',
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.emptyCartMessage,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Vai al menu'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      final hasCustomization = item.customization != null;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    
                                    // Mostra personalizzazione se presente
                                    if (hasCustomization) ...[
                                      const SizedBox(height: 8),
                                      if (item.customization!.base != null)
                                        Text(
                                          'Base: ${item.customization!.base!.name}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      if (item.customization!.addedIngredients.isNotEmpty)
                                        Text(
                                          '+ ${item.customization!.addedIngredients.join(', ')}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      if (item.customization!.removedIngredients.isNotEmpty)
                                        Text(
                                          '- ${item.customization!.removedIngredients.join(', ')}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.red[700],
                                          ),
                                        ),
                                      if (item.customization!.notes != null)
                                        Text(
                                          'Note: ${item.customization!.notes}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                    
                                    if (item.notes != null && item.notes!.isNotEmpty && !hasCustomization)
                                      Text(
                                        'Note: ${item.notes}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '${AppConstants.currencySymbol} ${item.price.toStringAsFixed(2)}',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        if (hasCustomization && item.customization!.getTotalExtraPrice() > 0)
                                          Text(
                                            ' + ${item.customization!.getTotalExtraPrice().toStringAsFixed(2)}€',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.green[700],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => cartProvider.decrementQuantity(index),
                                    icon: const Icon(Icons.remove_circle_outline),
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  IconButton(
                                    onPressed: () => cartProvider.incrementQuantity(index),
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  IconButton(
                                    onPressed: () => cartProvider.removeItem(index),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Totale:',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              '${AppConstants.currencySymbol} ${cartProvider.totalAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Procedi con l\'ordine'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Svuota carrello'),
        content: const Text('Sei sicuro di voler svuotare il carrello?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Svuota'),
          ),
        ],
      ),
    );
  }
}
