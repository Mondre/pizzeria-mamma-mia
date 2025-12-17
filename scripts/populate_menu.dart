import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_options.dart';

void main() async {
  // Inizializza Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final menuCollection = firestore.collection('menuItems');

  print('Inizio caricamento menu...');

  // Pizze Classiche
  final pizzeClassiche = [
    {'name': 'Focaccia', 'description': 'Olio, Sale', 'price': 5.50},
    {'name': 'Margherita', 'description': 'Pomodoro, mozzarella', 'price': 6.00},
    {'name': 'Marinara', 'description': 'Pomodoro, aglio, origano', 'price': 5.50},
    {'name': 'Napoli', 'description': 'Pomodoro, mozzarella, acciughe, origano', 'price': 7.50},
    {'name': 'Quattro Stagioni', 'description': 'Pomodoro, mozzarella, prosciutto cotto, funghi, carciofi', 'price': 8.50},
    {'name': 'Romana', 'description': 'Pomodoro, mozzarella, acciughe, capperi, origano', 'price': 8.00},
    {'name': 'Schiacciatina', 'description': 'Pomodoro, prosciutto cotto', 'price': 7.50},
    {'name': 'Funghi', 'description': 'Pomodoro, mozzarella, funghi', 'price': 7.50},
    {'name': 'Pugliese', 'description': 'Pomodoro, mozzarella, cipolla', 'price': 7.00},
    {'name': 'Prosciutto cotto e funghi', 'description': 'Pomodoro, mozzarella, prosciutto cotto, funghi', 'price': 8.00},
    {'name': 'Appetitosa', 'description': 'Mozzarella, prosciutto cotto, funghi, scaglie di grana', 'price': 8.50},
    {'name': 'Diavola', 'description': 'Pomodoro, mozzarella, salame piccante', 'price': 9.00},
    {'name': 'Primavera', 'description': 'Mozzarella, prosciutto cotto, olive pomodorini freschi, insalata', 'price': 8.50},
    {'name': 'Bufala', 'description': 'Pomodoro, mozzarella di bufala', 'price': 9.00},
    {'name': 'Tonno e cipolle', 'description': 'Pomodoro, mozzarella, tonno, cipolle', 'price': 9.50},
    {'name': 'Vegetariana', 'description': 'Pomodoro, mozzarella, melanzane, peperoni, zucchine', 'price': 9.00},
    {'name': 'Caprese', 'description': 'Pomodoro, mozzarella di bufala, pomodorini', 'price': 9.50},
    {'name': 'Rucola', 'description': 'Pomodoro, mozzarella di bufala, rucola', 'price': 9.50},
    {'name': 'Tonno', 'description': 'Pomodoro, mozzarella, tonno', 'price': 9.00},
    {'name': 'Carciofi', 'description': 'Pomodoro, mozzarella, carciofi', 'price': 7.50},
    {'name': 'Prosciutto cotto', 'description': 'Pomodoro, mozzarella, prosciutto cotto', 'price': 7.50},
    {'name': 'Wurstel', 'description': 'Pomodoro, mozzarella, wurstel', 'price': 7.50},
    {'name': 'Siciliana', 'description': 'Pomodoro, acciughe, capperi, olive, origano', 'price': 7.50},
    {'name': 'Gorgonzola', 'description': 'Pomodoro, mozzarella, gorgonzola', 'price': 8.00},
    {'name': 'Salsiccia', 'description': 'Pomodoro, mozzarella, salsiccia', 'price': 8.50},
    {'name': 'Capricciosa', 'description': 'Pomodoro, mozzarella, prosciutto cotto, funghi, carciofi', 'price': 8.50},
    {'name': 'Calzone normale', 'description': 'Pomodoro, mozzarella, prosciutto cotto', 'price': 8.50},
    {'name': '4 Formaggi', 'description': 'Pomodoro, mozzarella, gorgonzola, fontina, taleggio', 'price': 8.50},
    {'name': 'Peperoni', 'description': 'Pomodoro, mozzarella, peperoni', 'price': 8.50},
    {'name': 'Calzone farcito', 'description': 'Pomodoro, mozzarella, prosciutto cotto, funghi, carciofi', 'price': 9.50},
    {'name': 'Snoopy', 'description': 'Pomodoro, mozzarella, patatine fritte', 'price': 8.50},
    {'name': 'Prosciutto crudo', 'description': 'Pomodoro, mozzarella, prosciutto crudo', 'price': 9.50},
    {'name': 'Patatine e wurstel', 'description': 'Pomodoro, mozzarella, patatine fritte, wurstel', 'price': 9.00},
  ];

  // Pizze Speciali
  final pizzeSpeciali = [
    {'name': 'Sirena', 'description': 'Mozzarella, pomodori datterini gialli, grana, basilico, crema di pomodoro rosso', 'price': 11.00},
    {'name': 'Boh?', 'description': 'Mozzarella, pomodori secchi, peperoni, salsiccia, scaglie di limone e foglioline di menta', 'price': 14.00},
    {'name': 'Mamma mia', 'description': 'Pomodoro, mozzarella, scamorza, funghi, carciofi, cotto, peperoni, olive, würstel, salsiccia e patatine fritte', 'price': 12.50},
    {'name': 'Zola noci e pere', 'description': 'Mozzarella, gorgonzola, noci e pere', 'price': 10.00},
    {'name': 'Pollo e patate', 'description': 'Mozzarella, patate lesse, rosmarino e pancetta al forno', 'price': 10.50},
    {'name': 'Focaccia del corsaro', 'description': 'Pomodorini, tonno, gamberetti, bufala, rucola, prosciutto crudo, sale, olio e origano', 'price': 13.00},
    {'name': 'Frutti di mare', 'description': 'Pomodoro, mozzarella, frutti di mare, olive e origano', 'price': 11.50},
    {'name': 'Speciale', 'description': 'Pomodoro, mozzarella, patate lesse, rosmarino e scaglie di grana', 'price': 9.00},
    {'name': 'Speck', 'description': 'Pomodoro, mozzarella, speck', 'price': 9.50},
    {'name': 'Crudo e philadelphia', 'description': 'Pomodoro, mozzarella, prosciutto crudo e philadelphia', 'price': 10.50},
    {'name': 'Bresaola e rucola', 'description': 'Pomodoro, mozzarella, bresaola, rucola', 'price': 11.00},
    {'name': 'Mediterranea', 'description': 'Pomodoro, mozzarella, pomodori secchi e origano', 'price': 10.00},
    {'name': 'Estate', 'description': 'Mozzarella, cipolla rossa, fiori di zucca, limone grattugiato e pancetta', 'price': 12.00},
    {'name': 'Salsiccia e scarola', 'description': 'Mozzarella, scamorza, salsiccia e scarola', 'price': 11.50},
    {'name': '\'Nduja bein', 'description': 'Pomodoro, mozzarella, pomodori secchi e origano', 'price': 13.50},
    {'name': 'Speragi', 'description': 'Mozzarella, crema di sparagi, noci, speck', 'price': 11.00},
    {'name': 'Antichi sapori', 'description': 'Mozzarella, scarola, olive nere, acciughe, capperi, salame piccante', 'price': 11.00},
    {'name': 'Terra mia', 'description': 'Mozzarella, cipolla, nduja, bufala, gratuggiata di cacio ricotta', 'price': 11.00},
    {'name': 'Salmone', 'description': 'Pomodoro, mozzarella, salmone affumicato', 'price': 12.00},
    {'name': 'Palermo', 'description': 'Pomodoro, mozzarella, bufala, würstel, salamino e origano', 'price': 11.00},
    {'name': 'Profumo di venere', 'description': 'Mozzarella, pomodori secchi, tonno, pancetta e scaglie di grana', 'price': 11.50},
    {'name': 'Sfiziosa', 'description': 'Mozzarella, carciofini, pomodori secchi, bresaola, rucola e scaglie di grana', 'price': 12.00},
    {'name': 'Golden Rita', 'description': 'Pomodorini gialli, mozzarella, pepe nero, gratuggiata di cacio ricotta, basilico', 'price': 10.00},
    {'name': 'Nutella', 'description': 'Pane, nutella', 'price': 7.50},
    {'name': 'Tre pomodori', 'description': 'Pomodoro, pomodorini rossi, pomodorini gialli, aglio, olio, origano e burrata', 'price': 12.00},
    {'name': 'Funghi porcini', 'description': 'Pomodoro, mozzarella, funghi porcini', 'price': 9.50},
    {'name': 'Salsiccia e broccoli', 'description': 'Mozzarella, salsiccia e friarielli napoletani', 'price': 11.00},
    {'name': 'Gamberetti e rucola', 'description': 'Pomodoro, mozzarella, gamberetti e rucola', 'price': 11.50},
    {'name': 'Pancetta e rucola', 'description': 'Pomodoro, mozzarella, pancetta e rucola', 'price': 10.00},
    {'name': 'Bomber', 'description': 'Mozzarella, emmental, salamino, crocchè di patate', 'price': 11.00},
    {'name': 'Mordella', 'description': 'Doppio impasto, olio, mortadella, pistacchio, stracciatella', 'price': 12.50},
    {'name': 'Friariello bellillo', 'description': 'Mozzarella fior di latte, scamorza affumicata, salsiccia, crema di friarielli alla napoletana', 'price': 12.50},
    {'name': 'Speck & Brie', 'description': 'Pomodoro, mozzarella, speck, brie', 'price': 10.50},
    {'name': 'Ciao inverno ciao', 'description': 'Mozzarella, salsiccia, crema di tartufo, scaglie di tartufo', 'price': 12.00},
    {'name': 'Fiori di zucca', 'description': 'Bufala, ricotta, fiori di zucca, coppa', 'price': 11.00},
  ];

  // Mezzo Metro
  final mezzoMetro = [
    {'name': 'Mezzo Metro - Margherita', 'description': 'Pomodoro, mozzarella', 'price': 18.00},
    {'name': 'Mezzo Metro - Margherita + Misto', 'description': 'Metà Margherita, metà quello che vuoi (qualsiasi gusto)', 'price': 19.50},
    {'name': 'Mezzo Metro - Qualsiasi gusto', 'description': 'Metti su tutto il mezzo metro quello che vuoi', 'price': 23.00},
  ];

  // Bevande
  final bevande = [
    {'name': 'Coca Cola', 'description': 'Lattina 33cl', 'price': 3.50},
    {'name': 'Sprite', 'description': 'Lattina 33cl', 'price': 3.50},
    {'name': 'Fanta', 'description': 'Lattina 33cl', 'price': 3.50},
    {'name': 'Birra piccola', 'description': 'Artigianali, Ichnusa - 33cl', 'price': 4.00},
    {'name': 'Birra grande', 'description': 'Menabrea, Moretti - 66cl', 'price': 4.50},
    {'name': 'Vino Rosso', 'description': 'Bottiglia 75cl', 'price': 15.00},
    {'name': 'Vino Bianco', 'description': 'Bottiglia 75cl', 'price': 15.00},
    {'name': 'Acqua Naturale', 'description': '75cl', 'price': 2.00},
    {'name': 'Acqua Frizzante', 'description': '75cl', 'price': 2.00},
    {'name': 'Caffè', 'description': 'Espresso, decaffeinato', 'price': 1.50},
    {'name': 'Limoncello', 'description': 'Digestivo al limone', 'price': 1.50},
  ];

  // Dolci
  final dolci = [
    {'name': 'Tiramisù della Casa', 'description': 'Preparato secondo la ricetta tradizionale', 'price': 5.50},
    {'name': 'Panna Cotta', 'description': 'Con frutti di bosco', 'price': 4.50},
    {'name': 'Gelato', 'description': '3 palline - gusti assortiti', 'price': 4.00},
  ];

  int count = 0;

  // Carica Pizze Classiche
  for (var item in pizzeClassiche) {
    await menuCollection.add({
      'name': item['name'],
      'description': item['description'],
      'price': item['price'],
      'category': 'Pizze Classiche',
      'imageUrl': '',
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    count++;
    print('✓ ${item['name']}');
  }

  // Carica Pizze Speciali
  for (var item in pizzeSpeciali) {
    await menuCollection.add({
      'name': item['name'],
      'description': item['description'],
      'price': item['price'],
      'category': 'Pizze Speciali',
      'imageUrl': '',
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    count++;
    print('✓ ${item['name']}');
  }

  // Carica Mezzo Metro
  for (var item in mezzoMetro) {
    await menuCollection.add({
      'name': item['name'],
      'description': item['description'],
      'price': item['price'],
      'category': 'Mezzo Metro',
      'imageUrl': '',
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    count++;
    print('✓ ${item['name']}');
  }

  // Carica Bevande
  for (var item in bevande) {
    await menuCollection.add({
      'name': item['name'],
      'description': item['description'],
      'price': item['price'],
      'category': 'Bevande',
      'imageUrl': '',
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    count++;
    print('✓ ${item['name']}');
  }

  // Carica Dolci
  for (var item in dolci) {
    await menuCollection.add({
      'name': item['name'],
      'description': item['description'],
      'price': item['price'],
      'category': 'Dolci',
      'imageUrl': '',
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    count++;
    print('✓ ${item['name']}');
  }

  print('\n✅ Caricamento completato! $count articoli aggiunti al menu.');
  print('Puoi visualizzarli nell\'app.');
}
