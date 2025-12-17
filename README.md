# Pizzeria Mamma Mia 🍕

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)](https://firebase.google.com)

App multi-piattaforma per la gestione degli ordini della Pizzeria Mamma Mia.

## � Piattaforme Supportate

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows Desktop

## ✨ Caratteristiche Principali

### 👤 Modalità Cliente
- Registrazione e login
- Visualizzazione menu con categorie e ricerca
- Carrello con gestione quantità
- Invio e tracciamento ordini in tempo reale
- Storico ordini completo

### 👨‍💼 Modalità Admin
- Dashboard con statistiche in tempo reale
- Gestione ordini (visualizzazione, modifica stato, eliminazione)
- Stampa ordini in PDF
- Gestione menu completa (CRUD)
- Toggle disponibilità prodotti
- Filtri avanzati per stato ordine

## � Quick Start

### Prerequisiti

1. **Flutter SDK** (3.0 o superiore)
   ```powershell
   # Verifica installazione
   flutter doctor
   ```

2. **Firebase CLI**
   ```powershell
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

3. **Android Studio** (per Android)
4. **Visual Studio 2022** (per Windows Desktop)

### Installazione

1. **Apri il progetto**
   ```powershell
   cd "c:\VERA APP PIZZERIA MAMMA MIA"
   ```

2. **Installa le dipendenze**
   ```powershell
   flutter pub get
   ```

3. **Configura Firebase**
   ```powershell
   flutterfire configure
   ```

4. **Scarica google-services.json** (Android) da Firebase Console
   - Posiziona in: `android/app/google-services.json`

### Avvio

```powershell
# Android
flutter run -d android

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

## 📁 Struttura Progetto

```
lib/
├── main.dart                    # Entry point
├── models/                      # Modelli dati (Order, MenuItem, User)
├── services/                    # Servizi Firebase (Auth, Orders, Menu)
├── providers/                   # State management (Cart)
├── screens/                     # UI screens
│   ├── auth/                    # Login/Register
│   ├── client/                  # Interfaccia cliente
│   └── admin/                   # Interfaccia admin
├── widgets/                     # Widget riutilizzabili
└── utils/                       # Utility e costanti
```

## 🔧 Configurazione Firebase

1. Crea progetto su [Firebase Console](https://console.firebase.google.com/)
2. Abilita servizi:
   - **Authentication** (Email/Password)
   - **Cloud Firestore**
   - **Storage**
3. Aggiungi app per ogni piattaforma
4. Configura regole di sicurezza (vedi [SETUP_GUIDE.md](SETUP_GUIDE.md))

### Creare Account Admin

1. Registra utente nell'app
2. Firebase Console → Firestore → Collection `users`
3. Modifica documento: `isAdmin: true`

## 📚 Documentazione Completa

📖 **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Guida dettagliata con:
- Installazione Flutter passo-passo
- Configurazione Firebase completa
- Risoluzione problemi comuni
- Regole di sicurezza Firestore

## 🐛 Troubleshooting

```powershell
# Pulisci e reinstalla dipendenze
flutter clean
flutter pub get

# Verifica stato Flutter
flutter doctor -v
```

## 📦 Build per Produzione

```powershell
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## 📊 Tecnologie Utilizzate

- **Framework**: Flutter 3.x
- **Linguaggio**: Dart
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: Provider
- **PDF Generation**: printing, pdf
- **UI**: Material Design 3
- **Fonts**: Google Fonts

---

**Sviluppato con Flutter 💙 per Pizzeria Mamma Mia 🍕**
