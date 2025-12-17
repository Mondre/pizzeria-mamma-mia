import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class MenuService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MenuItem> _menuItems = [];
  bool _isLoading = false;

  MenuService() {
    _loadStaticMenu();
  }

  List<MenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;

  void _loadStaticMenu() {
    final now = DateTime.now();
    _menuItems = [
      // Pizze Classiche
      MenuItem(id: '1', name: 'Focaccia', description: 'Olio, Sale', price: 5.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '2', name: 'Margherita', description: 'Pomodoro, mozzarella', price: 6.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '3', name: 'Marinara', description: 'Pomodoro, aglio, origano', price: 5.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '4', name: 'Napoli', description: 'Pomodoro, mozzarella, acciughe, origano', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '5', name: 'Quattro Stagioni', description: 'Pomodoro, mozzarella, prosciutto cotto, funghi, carciofi', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '6', name: 'Romana', description: 'Pomodoro, mozzarella, acciughe, capperi, origano', price: 8.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '7', name: 'Schiacciatina', description: 'Pomodoro, prosciutto cotto', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '8', name: 'Funghi', description: 'Pomodoro, mozzarella, funghi', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '9', name: 'Pugliese', description: 'Pomodoro, mozzarella, cipolla', price: 7.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '10', name: 'Prosciutto cotto e funghi', description: 'Pomodoro, mozzarella, prosciutto cotto, funghi', price: 8.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '11', name: 'Appetitosa', description: 'Mozzarella, prosciutto cotto, funghi, scaglie di grana', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '12', name: 'Diavola', description: 'Pomodoro, mozzarella, salame piccante', price: 9.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '13', name: 'Primavera', description: 'Mozzarella, prosciutto cotto, olive pomodorini freschi, insalata', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '14', name: 'Bufala', description: 'Pomodoro, mozzarella di bufala', price: 9.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '15', name: 'Tonno e cipolle', description: 'Pomodoro, mozzarella, tonno, cipolle', price: 9.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '16', name: 'Vegetariana', description: 'Pomodoro, mozzarella, melanzane, peperoni, zucchine', price: 9.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '17', name: 'Caprese', description: 'Pomodoro, mozzarella di bufala, pomodorini', price: 9.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '18', name: 'Rucola', description: 'Pomodoro, mozzarella di bufala, rucola', price: 9.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '19', name: 'Tonno', description: 'Pomodoro, mozzarella, tonno', price: 9.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '20', name: 'Carciofi', description: 'Pomodoro, mozzarella, carciofi', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '21', name: 'Prosciutto cotto', description: 'Pomodoro, mozzarella, prosciutto cotto', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '22', name: 'Wurstel', description: 'Pomodoro, mozzarella, wurstel', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '23', name: 'Siciliana', description: 'Pomodoro, acciughe, capperi, olive, origano', price: 7.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '24', name: 'Gorgonzola', description: 'Pomodoro, mozzarella, gorgonzola', price: 8.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '25', name: 'Salsiccia', description: 'Pomodoro, mozzarella, salsiccia', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '26', name: 'Capricciosa', description: 'Pomodoro, mozzarella, prosciutto cotto, funghi, carciofi', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '27', name: 'Calzone normale', description: 'Pomodoro, mozzarella, prosciutto cotto', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '28', name: '4 Formaggi', description: 'Pomodoro, mozzarella, gorgonzola, fontina, taleggio', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '29', name: 'Peperoni', description: 'Pomodoro, mozzarella, peperoni', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '30', name: 'Calzone farcito', description: 'Pomodoro, mozzarella, prosciutto cotto, funghi, carciofi', price: 9.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '31', name: 'Snoopy', description: 'Pomodoro, mozzarella, patatine fritte', price: 8.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '32', name: 'Prosciutto crudo', description: 'Pomodoro, mozzarella, prosciutto crudo', price: 9.50, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '33', name: 'Patatine e wurstel', description: 'Pomodoro, mozzarella, patatine fritte, wurstel', price: 9.00, category: 'Pizze Classiche', imageUrl: null, ingredients: [], createdAt: now),
      
      // Pizze Speciali
      MenuItem(id: '34', name: 'Sirena', description: 'Mozzarella, pomodori datterini gialli, grana, basilico, crema di pomodoro rosso', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '35', name: 'Boh?', description: 'Mozzarella, pomodori secchi, peperoni, salsiccia, scaglie di limone e foglioline di menta', price: 14.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '36', name: 'Mamma mia', description: 'Pomodoro, mozzarella, scamorza, funghi, carciofi, cotto, peperoni, olive, würstel, salsiccia e patatine fritte', price: 12.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '37', name: 'Zola noci e pere', description: 'Mozzarella, gorgonzola, noci e pere', price: 10.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '38', name: 'Pollo e patate', description: 'Mozzarella, patate lesse, rosmarino e pancetta al forno', price: 10.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '39', name: 'Focaccia del corsaro', description: 'Pomodorini, tonno, gamberetti, bufala, rucola, prosciutto crudo, sale, olio e origano', price: 13.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '40', name: 'Frutti di mare', description: 'Pomodoro, mozzarella, frutti di mare, olive e origano', price: 11.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '41', name: 'Speciale', description: 'Pomodoro, mozzarella, patate lesse, rosmarino e scaglie di grana', price: 9.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '42', name: 'Speck', description: 'Pomodoro, mozzarella, speck', price: 9.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '43', name: 'Crudo e philadelphia', description: 'Pomodoro, mozzarella, prosciutto crudo e philadelphia', price: 10.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '44', name: 'Bresaola e rucola', description: 'Pomodoro, mozzarella, bresaola, rucola', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '45', name: 'Mediterranea', description: 'Pomodoro, mozzarella, pomodori secchi e origano', price: 10.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '46', name: 'Estate', description: 'Mozzarella, cipolla rossa, fiori di zucca, limone grattugiato e pancetta', price: 12.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '47', name: 'Salsiccia e scarola', description: 'Mozzarella, scamorza, salsiccia e scarola', price: 11.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '48', name: '\'Nduja bein', description: 'Pomodoro, mozzarella, nduja e stracciatella', price: 13.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '49', name: 'Speragi', description: 'Mozzarella, crema di sparagi, noci, speck', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '50', name: 'Antichi sapori', description: 'Mozzarella, scarola, olive nere, acciughe, capperi, salame piccante', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '51', name: 'Terra mia', description: 'Mozzarella, cipolla, nduja, bufala, gratuggiata di cacio ricotta', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '52', name: 'Salmone', description: 'Pomodoro, mozzarella, salmone affumicato', price: 12.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '53', name: 'Palermo', description: 'Pomodoro, mozzarella, bufala, würstel, salamino e origano', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '54', name: 'Profumo di venere', description: 'Mozzarella, pomodori secchi, tonno, pancetta e scaglie di grana', price: 11.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '55', name: 'Sfiziosa', description: 'Mozzarella, carciofini, pomodori secchi, bresaola, rucola e scaglie di grana', price: 12.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '56', name: 'Golden Rita', description: 'Pomodorini gialli, mozzarella, pepe nero, gratuggiata di cacio ricotta, basilico', price: 10.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '57', name: 'Nutella', description: 'Pane, nutella', price: 7.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '58', name: 'Tre pomodori', description: 'Pomodoro, pomodorini rossi, pomodorini gialli, aglio, olio, origano e burrata', price: 12.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '59', name: 'Funghi porcini', description: 'Pomodoro, mozzarella, funghi porcini', price: 9.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '60', name: 'Salsiccia e broccoli', description: 'Mozzarella, salsiccia e friarielli napoletani', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '61', name: 'Gamberetti e rucola', description: 'Pomodoro, mozzarella, gamberetti e rucola', price: 11.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '62', name: 'Pancetta e rucola', description: 'Pomodoro, mozzarella, pancetta e rucola', price: 10.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '63', name: 'Bomber', description: 'Mozzarella, emmental, salamino, crocchè di patate', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '64', name: 'Mordella', description: 'Doppio impasto, olio, mortadella, pistacchio, stracciatella', price: 12.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '65', name: 'Friariello bellillo', description: 'Mozzarella fior di latte, scamorza affumicata, salsiccia, crema di friarielli alla napoletana', price: 12.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '66', name: 'Speck & Brie', description: 'Pomodoro, mozzarella, speck, brie', price: 10.50, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '67', name: 'Ciao inverno ciao', description: 'Mozzarella, salsiccia, crema di tartufo, scaglie di tartufo', price: 12.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '68', name: 'Fiori di zucca', description: 'Bufala, ricotta, fiori di zucca, coppa', price: 11.00, category: 'Pizze Speciali', imageUrl: null, ingredients: [], createdAt: now),

      // Mezzo Metro
      MenuItem(id: '69', name: 'Mezzo Metro - Margherita', description: 'Pomodoro, mozzarella', price: 18.00, category: 'Mezzo Metro', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '70', name: 'Mezzo Metro - Margherita + Misto', description: 'Metà Margherita, metà quello che vuoi (qualsiasi gusto)', price: 19.50, category: 'Mezzo Metro', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '71', name: 'Mezzo Metro - Qualsiasi gusto', description: 'Metti su tutto il mezzo metro quello che vuoi', price: 23.00, category: 'Mezzo Metro', imageUrl: null, ingredients: [], createdAt: now),

      // Bevande
      MenuItem(id: '72', name: 'Coca Cola', description: 'Lattina 33cl', price: 3.50, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '73', name: 'Sprite', description: 'Lattina 33cl', price: 3.50, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '74', name: 'Fanta', description: 'Lattina 33cl', price: 3.50, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '75', name: 'Birra piccola', description: 'Artigianali, Ichnusa - 33cl', price: 4.00, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '76', name: 'Birra grande', description: 'Menabrea, Moretti - 66cl', price: 4.50, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '77', name: 'Vino Rosso', description: 'Bottiglia 75cl', price: 15.00, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '78', name: 'Vino Bianco', description: 'Bottiglia 75cl', price: 15.00, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '79', name: 'Acqua Naturale', description: '75cl', price: 2.00, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '80', name: 'Acqua Frizzante', description: '75cl', price: 2.00, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '81', name: 'Caffè', description: 'Espresso, decaffeinato', price: 1.50, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '82', name: 'Limoncello', description: 'Digestivo al limone', price: 1.50, category: 'Bevande', imageUrl: null, ingredients: [], createdAt: now),

      // Dolci
      MenuItem(id: '83', name: 'Tiramisù della Casa', description: 'Preparato secondo la ricetta tradizionale', price: 5.50, category: 'Dolci', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '84', name: 'Panna Cotta', description: 'Con frutti di bosco', price: 4.50, category: 'Dolci', imageUrl: null, ingredients: [], createdAt: now),
      MenuItem(id: '85', name: 'Gelato', description: '3 palline - gusti assortiti', price: 4.00, category: 'Dolci', imageUrl: null, ingredients: [], createdAt: now),
    ];
    notifyListeners();
  }

  // Stream di tutti i menu items
  Stream<List<MenuItem>> getMenuItemsStream() {
    return Stream.value(_menuItems);
  }

  // Carica menu items
  Future<void> loadMenuItems() async {
    // Il menu è già caricato staticamente nel costruttore
    // Questo metodo è mantenuto per compatibilità ma non fa nulla
    return Future.value();
  }

  // Ottieni items per categoria
  List<MenuItem> getItemsByCategory(String category) {
    return _menuItems.where((item) => item.category == category).toList();
  }

  // Ottieni tutte le categorie
  List<String> getCategories() {
    return _menuItems
        .map((item) => item.category)
        .toSet()
        .toList()
      ..sort();
  }

  // Aggiungi nuovo item (solo admin)
  Future<void> addMenuItem(MenuItem item) async {
    try {
      await _firestore.collection('menu_items').add(item.toMap());
      await loadMenuItems();
    } catch (e) {
      throw Exception('Errore nell\'aggiunta dell\'item: $e');
    }
  }

  // Aggiorna item esistente (solo admin)
  Future<void> updateMenuItem(MenuItem item) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(item.id)
          .update(item.toMap());
      await loadMenuItems();
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento dell\'item: $e');
    }
  }

  // Elimina item (solo admin)
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _firestore.collection('menu_items').doc(itemId).delete();
      await loadMenuItems();
    } catch (e) {
      throw Exception('Errore nell\'eliminazione dell\'item: $e');
    }
  }

  // Cambia disponibilità item
  Future<void> toggleAvailability(String itemId, bool available) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(itemId)
          .update({'available': available});
      await loadMenuItems();
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento della disponibilità: $e');
    }
  }

  // Cerca items
  List<MenuItem> searchItems(String query) {
    final lowerQuery = query.toLowerCase();
    return _menuItems.where((item) {
      return item.name.toLowerCase().contains(lowerQuery) ||
          item.description.toLowerCase().contains(lowerQuery) ||
          item.ingredients.any((ing) => ing.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
