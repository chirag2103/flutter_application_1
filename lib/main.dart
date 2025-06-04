import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/utils/firebase_config.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'screens/planning_screen.dart';
import 'screens/material_screen.dart';
import 'screens/labour_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/order_summary_screen.dart';
import 'screens/address_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  runApp(const ConstructionApp());
}

class ConstructionApp extends StatelessWidget {
  const ConstructionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Construction App',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/material': (context) => const MaterialScreen(),
        '/labour': (context) => const LabourScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/address': (context) => const AddressScreen(),
        '/chat': (context) => const ChatScreen(),
        '/notifications': (context) => const NotificationScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/order-summary':
            final cartItems =
                settings.arguments as List<Map<String, dynamic>>? ?? [];
            return MaterialPageRoute(
              builder: (context) => OrderSummaryScreen(cartItems: cartItems),
            );

          case '/payment':
            final totalAmount = settings.arguments as double? ?? 0.0;
            return MaterialPageRoute(
              builder: (context) => PaymentScreen(totalAmount: totalAmount),
            );

          default:
            return MaterialPageRoute(builder: (context) => HomeScreen());
        }
      },
    );
  }
}
