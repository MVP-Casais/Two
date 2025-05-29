import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart'; // ADICIONADO: para Locale
import 'package:provider/provider.dart';
import 'package:two/presentation/screens/profile/connection_information/connection_information_screen.dart';
import 'package:two/providers/atividade_provider.dart';
import 'package:two/providers/memories_provider.dart';
import 'package:two/providers/password_reset_provider.dart';
import 'package:two/providers/presence_provider.dart';
import 'package:two/providers/register_provider.dart';
import 'package:two/providers/login_provider.dart';
import 'package:two/providers/profile_provider.dart';
import 'package:two/providers/change_password_provider.dart';
import 'package:two/providers/planner_provider.dart';
import 'package:two/providers/connection_provider.dart';
import 'package:two/presentation/screens/baseScreen/activities/activities_screen.dart';
import 'package:two/presentation/screens/baseScreen/base_screen.dart';
import 'package:two/presentation/screens/baseScreen/memories/memories_screen.dart';
import 'package:two/presentation/screens/baseScreen/planner/planner_screen.dart';
import 'package:two/presentation/screens/baseScreen/presenceMode/presence_mode.dart';
import 'package:two/presentation/screens/profile/profile_screen.dart';
import 'package:two/presentation/screens/ranking/ranking_screen.dart';
import 'package:two/presentation/screens/register/help_register.dart';
import 'package:two/presentation/screens/tutorial/tutorial.dart';
import 'package:two/services/profile_service.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/login/login.dart';
import 'presentation/screens/pre_login/pre_login.dart';
import 'presentation/screens/login/help_page.dart';
import 'presentation/screens/baseScreen/home/home_screen.dart';
import 'package:two/providers/casais_provider.dart';
import 'package:two/providers/ranking_provider.dart';
import 'package:two/providers/app_usage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('pt_BR', null); 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => PlannerProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => AtividadeProvider()),
        ChangeNotifierProvider(create: (_) => MemoriesProvider()),
        ChangeNotifierProvider(create: (_) => PresenceProvider()),
        ChangeNotifierProvider(create: (_) => PasswordResetProvider()),
        ChangeNotifierProvider(create: (_) => CasaisProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(create: (_) => AppUsageProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/presence-mode': (context) => PresenceModeScreen(),
        '/base': (context) => BaseScreen(),
        '/ranking': (context) => const RankingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/connection': (context) => const ConnectionInformationScreen(),

      },
      locale: const Locale('pt', 'BR'), // ADICIONADO: define o locale do app (opcional, mas ajuda)
    );
  }
}
