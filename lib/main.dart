import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/recipe_provider.dart';
import 'screens/landing.dart';
import 'screens/login.dart';
import 'screens/signin.dart';
import 'screens/home.dart';
import 'utils/seed_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        // Show loading screen while initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.orange[900],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Initializing Firebase...',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show error screen if initialization failed
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.red[900],
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 60),
                      SizedBox(height: 20),
                      Text(
                        'Firebase Initialization Failed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Please check:\n'
                        '1. Firebase project is created\n'
                        '2. Cloud Firestore database is enabled\n'
                        '3. google-services.json is correct',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Firebase initialized successfully
        return ChangeNotifierProvider(
          create: (_) => RecipeProvider(),
          child: MaterialApp(
            title: 'Recipe App',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.orange,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const LandingPage(),
            routes: {
              '/landing': (context) => const LandingPage(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/home': (context) => const HomeScreen(),
            },
          ),
        );
      },
    );
  }

  Future<void> _initializeFirebase() async {
    try {
      print('🚀 Starting Firebase initialization...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully!');

      print('🌱 Starting database seeding...');
      await seedRecipes();
      print('✅ Seeding completed!');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}
