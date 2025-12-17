# Istruzioni di Setup - Pizzeria Mamma Mia

## ✅ Completato

Ho creato la struttura completa dell'applicazione Flutter per la Pizzeria Mamma Mia! 

### Struttura del Progetto

```
lib/
├── main.dart                           # Entry point dell'app
├── models/                             # Modelli dati
│   ├── user_model.dart
│   ├── menu_item.dart
│   ├── cart_item.dart
│   └── order.dart
├── services/                           # Servizi Firebase
│   ├── auth_service.dart               # Autenticazione
│   ├── menu_service.dart               # Gestione menu
│   └── order_service.dart              # Gestione ordini
├── providers/                          # State Management
│   └── cart_provider.dart              # Gestione carrello
├── screens/                            # Schermate UI
│   ├── auth/
│   │   ├── login_screen.dart           # Login
│   │   └── register_screen.dart        # Registrazione
│   ├── client/
│   │   ├── menu_screen.dart            # Menu per clienti
│   │   ├── cart_screen.dart            # Carrello
│   │   └── orders_screen.dart          # Ordini cliente
│   └── admin/
│       ├── admin_dashboard.dart        # Dashboard admin
│       ├── order_management_screen.dart # Gestione ordini
│       └── menu_management_screen.dart # Gestione menu
├── widgets/                            # Widget riutilizzabili
│   └── menu_item_card.dart
└── utils/                              # Utility e costanti
    ├── theme.dart                      # Tema dell'app
    └── constants.dart                  # Costanti

```

## 🚀 Prossimi Passi

### 1. Installa Flutter

**IMPORTANTE**: Prima di procedere, devi installare Flutter sul tuo sistema Windows.

1. Scarica Flutter: https://docs.flutter.dev/get-started/install/windows
2. Estrai il file ZIP in `C:\src\flutter`
3. Aggiungi `C:\src\flutter\bin` alle variabili d'ambiente PATH
4. Apri un nuovo terminale PowerShell e verifica l'installazione:
   ```powershell
   flutter doctor
   ```

### 2. Configura Firebase

1. Vai su [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuovo progetto "Pizzeria Mamma Mia"
3. Abilita i servizi:
   - **Authentication** → Abilita "Email/Password"
   - **Cloud Firestore** → Crea database in modalità test
   - **Storage** → Crea storage bucket

4. Aggiungi le app alle piattaforme:

**Per Android:**
   - Clicca "Aggiungi app" → Android
   - Package name: `com.mammamia.pizzeria`
   - Scarica `google-services.json`
   - Posizionalo in: `android/app/google-services.json`

**Per Web:**
   - Clicca "Aggiungi app" → Web
   - Copia la configurazione Firebase

5. Installa Firebase CLI:
   ```powershell
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

### 3. Installa le Dipendenze

```powershell
flutter pub get
```

### 4. Configura le Piattaforme

**Per Android** (Emulatore):
- Installa [Android Studio](https://developer.android.com/studio)
- Configura un emulatore Android
- Avvia l'emulatore

**Per Windows Desktop**:
- Installa [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/)
- Scegli "Desktop development with C++"

**Per Web**:
```powershell
flutter config --enable-web
```

### 5. Avvia l'App

```powershell
# Android
flutter run -d android

# Windows Desktop
flutter run -d windows

# Web
flutter run -d chrome
```

## 🎯 Funzionalità Implementate

### Modalità Cliente:
- ✅ Login e registrazione
- ✅ Visualizzazione menu con categorie
- ✅ Ricerca prodotti
- ✅ Carrello con gestione quantità
- ✅ Invio ordini
- ✅ Tracciamento ordini in tempo reale

### Modalità Admin:
- ✅ Dashboard con statistiche
- ✅ Gestione ordini in tempo reale
- ✅ Modifica stato ordini
- ✅ Eliminazione ordini
- ✅ Stampa ordini (PDF)
- ✅ Gestione menu (CRUD)
- ✅ Toggle disponibilità prodotti

## 👥 Account Admin

Per creare un account admin:

1. Registra un nuovo utente nell'app
2. Vai su Firebase Console → Firestore Database
3. Trova la collezione `users`
4. Trova il documento del tuo utente
5. Aggiungi/modifica il campo: `isAdmin: true`

Oppure crea manualmente un documento nella collezione `users`:
```json
{
  "email": "admin@mammamia.it",
  "name": "Admin",
  "phone": "1234567890",
  "isAdmin": true,
  "createdAt": [timestamp]
}
```

Poi crea l'account corrispondente in Firebase Authentication.

## 📱 Test dell'Applicazione

1. **Test Cliente**:
   - Registra un nuovo utente
   - Esplora il menu
   - Aggiungi prodotti al carrello
   - Effettua un ordine
   - Controlla lo stato dell'ordine

2. **Test Admin**:
   - Accedi con account admin
   - Visualizza ordini in arrivo
   - Cambia stato ordini
   - Stampa un ordine
   - Gestisci il menu (aggiungi/modifica/elimina prodotti)

## 🎨 Personalizzazione

### Colori
Modifica i colori in [lib/utils/theme.dart](lib/utils/theme.dart):
```dart
static const Color primaryColor = Color(0xFFD32F2F); // Rosso pizzeria
static const Color secondaryColor = Color(0xFFFFA000); // Arancione
```

### Logo
Aggiungi il logo della pizzeria:
1. Crea la cartella `assets/images/`
2. Aggiungi `logo.png`
3. Aggiorna `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/logo.png
```

## 🐛 Risoluzione Problemi

### Firebase non configurato
```
Errore: Firebase non inizializzato
```
**Soluzione**: Assicurati di aver eseguito `flutterfire configure`

### Dipendenze mancanti
```
Errore: Package not found
```
**Soluzione**: Esegui `flutter pub get`

### Emulatore non trovato
```
No devices found
```
**Soluzione**: 
- Android: Avvia un emulatore da Android Studio
- Windows: Usa `-d windows`
- Web: Usa `-d chrome`

## 📞 Supporto

Per problemi tecnici:
1. Controlla i log: `flutter doctor -v`
2. Pulisci il progetto: `flutter clean && flutter pub get`
3. Riavvia l'IDE

## 🔐 Sicurezza

**IMPORTANTE**: Prima di andare in produzione:

1. Configura le regole di sicurezza Firestore:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read their own data
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Menu items are readable by all authenticated users
    match /menu_items/{itemId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Orders
    match /orders/{orderId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

2. Configura Storage rules per le immagini
3. Abilita App Check per protezione da abusi

---

**Progetto creato con ❤️ per Pizzeria Mamma Mia**
