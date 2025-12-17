import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/pizza_ingredient.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  // Aggiungi item al carrello
  void addItem(MenuItem menuItem, {String? notes}) {
    final existingIndex = _items.indexWhere(
      (item) => item.menuItemId == menuItem.id && item.notes == notes && item.customization == null,
    );

    if (existingIndex >= 0) {
      // Incrementa quantità se già presente
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      // Aggiungi nuovo item
      _items.add(CartItem(
        menuItemId: menuItem.id,
        name: menuItem.name,
        price: menuItem.price,
        quantity: 1,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  // Aggiungi item con personalizzazione
  void addItemWithCustomization(MenuItem menuItem, PizzaCustomization customization) {
    // Le pizze personalizzate sono sempre nuovi item (non si raggruppano)
    _items.add(CartItem(
      menuItemId: menuItem.id,
      name: menuItem.name,
      price: menuItem.price,
      quantity: 1,
      customization: customization,
    ));
    notifyListeners();
  }

  // Aggiungi CartItem direttamente (per pizze create da zero)
  void addCartItem(CartItem cartItem) {
    _items.add(cartItem);
    notifyListeners();
  }

  // Rimuovi item dal carrello
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  // Aggiorna quantità
  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length) {
      if (quantity <= 0) {
        removeItem(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
        notifyListeners();
      }
    }
  }

  // Incrementa quantità
  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  // Decrementa quantità
  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
        notifyListeners();
      } else {
        removeItem(index);
      }
    }
  }

  // Svuota carrello
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
