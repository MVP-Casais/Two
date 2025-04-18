import 'package:flutter/material.dart';
import 'package:two/presentation/screens/memories/memories_screen.dart';
import 'package:two/presentation/screens/register/help_register.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/login/login.dart';
import 'presentation/screens/pre_login/pre_login.dart';
import 'presentation/screens/login/help_page.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/pre-login': (context) => const PreLoginPage(),
        '/login': (context) => const LoginPage(),
        '/help-login': (context) => const HelpPage(),
        '/help-register': (context) => const HelpPageRegister(),
        '/home': (context) => const HomeScreen(),
        '/memories': (context) => const MemoriesScreen(),
      },
    );
  }
}
