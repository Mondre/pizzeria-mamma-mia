class AppConstants {
  // App Info
  static const String appName = 'Pizzeria Mamma Mia';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String menuItemsCollection = 'menu_items';

  // Categorie Menu
  static const List<String> menuCategories = [
    'Pizza',
    'Antipasti',
    'Primi',
    'Secondi',
    'Contorni',
    'Dolci',
    'Bevande',
  ];

  // Stati Ordine
  static const Map<String, String> orderStatusLabels = {
    'pending': 'In attesa',
    'accepted': 'Accettato',
    'preparing': 'In preparazione',
    'ready': 'Pronto',
    'delivered': 'Consegnato',
    'cancelled': 'Annullato',
  };

  // Limiti
  static const int maxCartItems = 50;
  static const int minOrderAmount = 10; // Euro
  static const int maxOrderAmount = 500; // Euro

  // Messaggi
  static const String emptyCartMessage = 'Il carrello è vuoto';
  static const String emptyOrdersMessage = 'Nessun ordine trovato';
  static const String emptyMenuMessage = 'Menu non disponibile';
  static const String orderSuccessMessage = 'Ordine inviato con successo!';
  static const String orderErrorMessage = 'Errore nell\'invio dell\'ordine';

  // Formati
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String currencySymbol = '€';

  // Validazione
  static const int minPasswordLength = 6;
  static const int minNameLength = 2;
  static const int phoneLength = 10;

  // Regex
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phoneRegex = RegExp(
    r'^[0-9]{10}$',
  );

  // Durata animazioni
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Spaziature
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
}
