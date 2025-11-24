import 'package:flutter/material.dart';

// Pages
import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/register_page.dart';
import 'package:app/pages/cart_page.dart';
import 'package:app/pages/payment_page.dart';
import 'package:app/pages/shop_page.dart';
import 'package:app/pages/about_page.dart';
import 'package:app/pages/contact_page.dart';

// Theme Colors
const Color primaryGreen = Color(0xFF2D6A4F);
const Color lightGreen = Color(0xFFE6F4EA);
const Color darkGreenText = Color(0xFF1B4332);

void main() {
  runApp(const BaklawatiApp());
}

class BaklawatiApp extends StatelessWidget {
  const BaklawatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baklawati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen),
        scaffoldBackgroundColor: lightGreen,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: darkGreenText),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/cart': (context) => const CartPage(),
        '/payment': (context) => const PaymentPage(),
        '/shop': (context) => const ShopPage(),
        '/about': (context) => const AboutPage(),
        '/contact': (context) => const ContactPage(),
      },
    );
  }
}
