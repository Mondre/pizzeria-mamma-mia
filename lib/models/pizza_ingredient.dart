class PizzaIngredient {
  final String name;
  final double price;
  final String? note;

  const PizzaIngredient({
    required this.name,
    required this.price,
    this.note,
  });
}

class PizzaBase {
  final String name;
  final double basePrice;

  const PizzaBase({
    required this.name,
    this.basePrice = 0.0,
  });
}

class PizzaCustomization {
  final PizzaBase? base;
  final List<String> addedIngredients;
  final List<String> removedIngredients;
  final String? notes;

  const PizzaCustomization({
    this.base,
    this.addedIngredients = const [],
    this.removedIngredients = const [],
    this.notes,
  });

  double getTotalExtraPrice() {
    double total = 0;
    for (var ingredient in addedIngredients) {
      final ing = PizzaIngredients.allIngredients.firstWhere(
        (i) => i.name == ingredient,
        orElse: () => const PizzaIngredient(name: '', price: 0),
      );
      total += ing.price;
    }
    return total;
  }

  Map<String, dynamic> toMap() {
    return {
      'base': base?.name,
      'addedIngredients': addedIngredients,
      'removedIngredients': removedIngredients,
      'notes': notes,
    };
  }

  factory PizzaCustomization.fromMap(Map<String, dynamic> map) {
    return PizzaCustomization(
      base: map['base'] != null ? PizzaBase(name: map['base']) : null,
      addedIngredients: List<String>.from(map['addedIngredients'] ?? []),
      removedIngredients: List<String>.from(map['removedIngredients'] ?? []),
      notes: map['notes'],
    );
  }
}

class PizzaIngredients {
  // Basi disponibili
  static const List<PizzaBase> bases = [
    PizzaBase(name: 'Bianca', basePrice: 5.0),
    PizzaBase(name: 'Rossa', basePrice: 5.0),
    PizzaBase(name: 'Margherita', basePrice: 6.0),
    PizzaBase(name: 'Saltinbocca', basePrice: 5.0),
  ];

  // Ingredienti da 1.50€
  static const List<PizzaIngredient> ingredients1_50 = [
    PizzaIngredient(name: 'Capperi', price: 1.50),
    PizzaIngredient(name: 'Cipolle', price: 1.50),
    PizzaIngredient(name: 'Funghi', price: 1.50),
    PizzaIngredient(name: 'Melanzane', price: 1.50),
    PizzaIngredient(name: 'Olive', price: 1.50),
    PizzaIngredient(name: 'Patatine Fritte', price: 1.50, note: 'Il prodotto potrebbe essere surgelato'),
    PizzaIngredient(name: 'Peperoni', price: 1.50),
    PizzaIngredient(name: 'Zucchine', price: 1.50),
    PizzaIngredient(name: 'Wurstel', price: 1.50),
    PizzaIngredient(name: 'Olio all\'aglio', price: 1.50),
  ];

  // Ingredienti da 2.50€
  static const List<PizzaIngredient> ingredients2_50 = [
    PizzaIngredient(name: 'Pomodori', price: 2.50),
    PizzaIngredient(name: 'Carciofi', price: 2.50),
    PizzaIngredient(name: 'Pomodorini', price: 2.50),
    PizzaIngredient(name: 'Rucola', price: 2.50),
    PizzaIngredient(name: 'Prosciutto Cotto', price: 2.50),
    PizzaIngredient(name: 'Salsiccia', price: 2.50),
    PizzaIngredient(name: 'Emmental', price: 2.50),
    PizzaIngredient(name: 'Gorgonzola', price: 2.50),
    PizzaIngredient(name: 'Grana', price: 2.50),
    PizzaIngredient(name: 'Mozzarella', price: 2.50),
    PizzaIngredient(name: 'Philadelphia', price: 2.50),
    PizzaIngredient(name: 'Ricotta', price: 2.50),
    PizzaIngredient(name: 'Scamorza', price: 2.50),
    PizzaIngredient(name: 'Acciughe', price: 2.50),
    PizzaIngredient(name: 'Tonno', price: 2.50),
  ];

  // Ingredienti da 3.50€
  static const List<PizzaIngredient> ingredients3_50 = [
    PizzaIngredient(name: 'Porcini', price: 3.50),
    PizzaIngredient(name: 'Pere', price: 3.50),
    PizzaIngredient(name: 'Tartufo Fresco', price: 3.50),
    PizzaIngredient(name: 'Bresaola', price: 3.50),
    PizzaIngredient(name: 'Prosciutto Crudo', price: 3.50),
    PizzaIngredient(name: 'Salame Dolce', price: 3.50),
    PizzaIngredient(name: 'Speck', price: 3.50),
    PizzaIngredient(name: 'Bufala', price: 3.50),
    PizzaIngredient(name: 'Stracciatella', price: 3.50),
    PizzaIngredient(name: 'Pancetta', price: 3.50),
    PizzaIngredient(name: 'Salame Piccante', price: 3.50),
  ];

  // Ingredienti da 7.00€
  static const List<PizzaIngredient> ingredients7_00 = [
    PizzaIngredient(name: 'Frutti di Mare', price: 7.00, note: 'Questo prodotto potrebbe essere congelato'),
    PizzaIngredient(name: 'Salmone', price: 7.00, note: 'Questo prodotto potrebbe essere congelato'),
    PizzaIngredient(name: 'Gamberetti', price: 7.00, note: 'Questo prodotto potrebbe essere congelato'),
  ];

  // Tutti gli ingredienti
  static List<PizzaIngredient> get allIngredients => [
    ...ingredients1_50,
    ...ingredients2_50,
    ...ingredients3_50,
    ...ingredients7_00,
  ];

  // Raggruppa per prezzo
  static Map<double, List<PizzaIngredient>> get ingredientsByPrice => {
    1.50: ingredients1_50,
    2.50: ingredients2_50,
    3.50: ingredients3_50,
    7.00: ingredients7_00,
  };
}
