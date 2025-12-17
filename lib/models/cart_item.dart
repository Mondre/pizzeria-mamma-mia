import 'pizza_ingredient.dart';

class CartItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? notes;
  final PizzaCustomization? customization;

  CartItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
    this.customization,
  });

  double get totalPrice {
    double baseTotal = price * quantity;
    if (customization != null) {
      baseTotal += customization!.getTotalExtraPrice() * quantity;
    }
    return baseTotal;
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'notes': notes,
      'customization': customization?.toMap(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      menuItemId: map['menuItemId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      notes: map['notes'],
      customization: map['customization'] != null 
          ? PizzaCustomization.fromMap(map['customization'])
          : null,
    );
  }

  CartItem copyWith({
    String? menuItemId,
    String? name,
    double? price,
    int? quantity,
    String? notes,
    PizzaCustomization? customization,
  }) {
    return CartItem(
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      customization: customization ?? this.customization,
    );
  }
}
