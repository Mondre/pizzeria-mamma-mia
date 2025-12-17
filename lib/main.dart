import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/order_service.dart';
import 'services/menu_service.dart';
import 'services/notification_service.dart';
import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/client/menu_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'utils/theme.dart';
import 'widgets/cookie_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inizializza formattazione date italiane
  await initializeDateFormatting('it_IT', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProxyProvider<NotificationService, OrderService>(
          create: (context) => OrderService(Provider.of<NotificationService>(context, listen: false)),
          update: (context, notificationService, orderService) => orderService ?? OrderService(notificationService),
        ),
        ChangeNotifierProvider(create: (_) => MenuService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Pizzeria Mamma Mia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        Widget mainWidget;
        if (snapshot.hasData) {
          // Utente autenticato - controlla se è admin
          mainWidget = FutureBuilder<bool>(
            future: authService.isAdmin(),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (adminSnapshot.data == true) {
                // Mostra dashboard admin
                return const AdminDashboard();
              } else {
                // Mostra interfaccia cliente
                return const MenuScreen();
              }
            },
          );
        } else {
          // Utente non autenticato - mostra login
          mainWidget = const LoginScreen();
        }

        // Wrap con Stack per mostrare il cookie banner sopra tutto
        return Stack(
          children: [
            mainWidget,
            const CookieBanner(),
          ],
        );
      },
    );
  }
}
