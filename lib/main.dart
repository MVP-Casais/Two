import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // ADICIONADO: para Locale
import 'package:two/presentation/screens/baseScreen/activities/activities_screen.dart';
import 'package:two/presentation/screens/baseScreen/base_screen.dart';
import 'package:two/presentation/screens/baseScreen/memories/memories_screen.dart';
import 'package:two/presentation/screens/baseScreen/planner/planner_screen.dart';
import 'package:two/presentation/screens/baseScreen/settings/settings_screen.dart';
import 'package:two/presentation/screens/profile/profile_screen.dart';
import 'package:two/presentation/screens/ranking/ranking_screen.dart';
import 'package:two/presentation/screens/register/help_register.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/login/login.dart';
import 'presentation/screens/pre_login/pre_login.dart';
import 'presentation/screens/login/help_page.dart';
import 'presentation/screens/baseScreen/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ADICIONADO: para async/await funcionar no main
  await initializeDateFormatting('pt_BR', null); // ADICIONADO: inicializar datas em português
  runApp(const MyApp());
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
        '/home': (context) => HomeScreen(),
        '/memories': (context) => MemoriesScreen(),
        '/activities': (context) => const ActivitiesScreen(),
        '/planner': (context) => const PlannerScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/base': (context) => BaseScreen(),
        '/ranking': (context) => const RankingScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      locale: const Locale('pt', 'BR'), // ADICIONADO: define o locale do app (opcional, mas ajuda)
    );
  }
}
