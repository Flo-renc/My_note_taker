# note_taker_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
#  Note Taker App

A simple Flutter + Firebase notes app that supports full CRUD (Create, Read, Update, Delete) operations with secure user authentication using email and password.

##  Features

-  Firebase Authentication (Sign-up & Log-in)
-  Create, edit, and delete personal notes
-  Syncs with Firestore in real-time
-  State management using `Provider`
-  Responsive UI with hint text when empty
-  Persistent login session

---

##  Getting Started

###  Prerequisites

- Flutter SDK installed (version 3.x+)
- Firebase project created
- Android Studio or VS Code installed
- A connected Android device or emulator

---

###  Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable **Email/Password** under **Authentication > Sign-in method**
4. Create a Firestore database in test mode
5. Add your Android app in Firebase and download the `google-services.json` file
6. Place the `google-services.json` file inside `android/app/`

---

###  Install Dependencies

```bash
flutter pub get
