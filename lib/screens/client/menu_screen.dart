import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/menu_service.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../providers/cart_provider.dart';
import '../../models/menu_item.dart';
import '../../widgets/menu_item_card.dart';
import '../../models/pizza_ingredient.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'create_pizza_screen.dart';
import 'pizza_customization_dialog.dart';
import 'notifications_screen.dart';
import 'my_complaints_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_conditions_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Tutte';
  final _searchController = TextEditingController();
  int _lastNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuService>(context, listen: false).loadMenuItems();
      _listenToNotifications();
    });
  }

  void _listenToNotifications() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      notificationService.getUnreadCountStream(user.uid).listen((count) {
        if (mounted && count > _lastNotificationCount && _lastNotificationCount > 0) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hai una nuova notifica!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.blue.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Vedi',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
            ),
          );
        }
        _lastNotificationCount = count;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuService = Provider.of<MenuService>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final notificationService = Provider.of<NotificationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          // Reclami
          IconButton(
            icon: const Icon(Icons.report_problem_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyComplaintsScreen(),
                ),
              );
            },
            tooltip: 'I miei reclami',
          ),
          // Notifiche con badge
          if (user != null)
            StreamBuilder<int>(
              stream: notificationService.getUnreadCountStream(user.uid),
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          // Carrello
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Menu
          PopupMenuButton<String>(
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'notifications',
                child: Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 8),
                    Text('Notifiche'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'orders',
                child: Row(
                  children: [
                    Icon(Icons.receipt_long),
                    SizedBox(width: 8),
                    Text('I miei ordini'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'complaints',
                child: Row(
                  children: [
                    Icon(Icons.report_problem),
                    SizedBox(width: 8),
                    Text('I miei reclami'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profilo'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'privacy',
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined),
                    SizedBox(width: 8),
                    Text('Privacy Policy'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'terms',
                child: Row(
                  children: [
                    Icon(Icons.description_outlined),
                    SizedBox(width: 8),
                    Text('Termini e Condizioni'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete_account',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Text('Elimina Account', style: TextStyle(color: Colors.red[700])),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Esci'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'notifications') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              } else if (value == 'orders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ),
                );
              } else if (value == 'complaints') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyComplaintsScreen(),
                  ),
                );
              } else if (value == 'privacy') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              } else if (value == 'terms') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              } else if (value == 'delete_account') {
                _showDeleteAccountDialog(context, authService);
              } else if (value == 'logout') {
                authService.signOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra ricerca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca nel menu...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Categorie
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('Tutte'),
                ...menuService.getCategories().map(
                      (category) => _buildCategoryChip(category),
                    ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Pulsante Crea la tua Pizza
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePizzaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Crea la tua Pizza'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Lista menu
          Expanded(
            child: menuService.isLoading
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<List<MenuItem>>(
                    stream: menuService.getMenuItemsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Errore: ${snapshot.error}'),
                        );
                      }

                      var items = snapshot.data ?? [];

                      // Filtra per categoria
                      if (_selectedCategory != 'Tutte') {
                        items = items
                            .where((item) => item.category == _selectedCategory)
                            .toList();
                      }

                      // Filtra per ricerca
                      if (_searchController.text.isNotEmpty) {
                        items = menuService.searchItems(_searchController.text);
                      }

                      if (items.isEmpty) {
                        return const Center(
                          child: Text('Nessun prodotto trovato'),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isPizza = item.category == 'Pizze Classiche' || 
                                        item.category == 'Pizze Speciali' ||
                                        item.category == 'Mezzo Metro';
                          
                          return MenuItemCard(
                            item: item,
                            onAddToCart: () async {
                              if (isPizza) {
                                // Mostra dialog di personalizzazione per le pizze
                                final customization = await showDialog<PizzaCustomization>(
                                  context: context,
                                  builder: (context) => PizzaCustomizationDialog(pizza: item),
                                );
                                
                                if (customization != null) {
                                  cartProvider.addItemWithCustomization(item, customization);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${item.name} aggiunto al carrello'),
                                        duration: const Duration(milliseconds: 1500),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                // Aggiungi direttamente per gli altri prodotti
                                cartProvider.addItem(item);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${item.name} aggiunto al carrello'),
                                      duration: const Duration(milliseconds: 1500),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context, AuthService authService) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Elimina Account'),
      content: const Text(
        'Sei sicuro di voler eliminare il tuo account?\n\n'
        'Questa azione è irreversibile e comporterà:\n'
        '• Cancellazione di tutti i tuoi dati personali\n'
        '• Perdita dello storico ordini\n'
        '• Impossibilità di recuperare l\'account\n\n'
        'Per procedere, conferma la tua identità.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            Navigator.pop(context);
            _showPasswordConfirmDialog(context, authService);
          },
          child: const Text('Elimina'),
        ),
      ],
    ),
  );
}

void _showPasswordConfirmDialog(BuildContext context, AuthService authService) {
  final passwordController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Conferma Password'),
      content: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          hintText: 'Inserisci la tua password',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            try {
              // Qui dovresti implementare la logica di eliminazione account
              // che include re-autenticazione e cancellazione da Firebase
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Per completare l\'eliminazione, contatta l\'assistenza.\n'
                    'I tuoi dati saranno cancellati entro 30 giorni.',
                  ),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.orange,
                ),
              );
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Errore: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Conferma Eliminazione'),
        ),
      ],
    ),
  );
}
