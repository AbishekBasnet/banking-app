import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

/// Main entry point of the Banking App
/// Initializes the Flutter application with RBC-inspired theme
void main() {
  runApp(const BankingApp());
}

/// Root widget of the application
class BankingApp extends StatelessWidget {
  const BankingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title
      title: 'Banking App',
      
      // Remove debug banner
      debugShowCheckedModeBanner: false,
      
      // App theme with RBC-inspired colors
      theme: ThemeData(
        // Primary color (Royal Blue)
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF005DAA),
        
        // Accent color (Gold)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005DAA),
          secondary: const Color(0xFFFFD700),
        ),
        
        // Font family (default system font)
        fontFamily: 'Roboto',
        
        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF005DAA),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        
        // Card theme
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005DAA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
        
        // Text theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003D71),
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003D71),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF003D71),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        
        // Use Material 3
        useMaterial3: true,
      ),
      
      // Set the Welcome Screen as the home screen (first screen)
      // Navigation flow: Welcome → Dashboard (with bottom nav: Home, Accounts, Most Money, More)
      home: const WelcomeScreen(),
    );
  }
}
