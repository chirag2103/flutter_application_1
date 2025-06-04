import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDXVEwCVnkwxHGJcTRfOJaOYpVRKYBhQJk", // Web API Key
        authDomain: "constructionapp-18a34.firebaseapp.com",
        projectId: "constructionapp-18a34",
        storageBucket: "constructionapp-18a34.appspot.com",
        messagingSenderId: "105767508342518951338",
        appId:
            "1:105767508342518951338:web:YOUR_APP_ID", // You'll need to add your Web App ID
      ),
    );
  }
}
