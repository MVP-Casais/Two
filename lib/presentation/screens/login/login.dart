import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/providers/login_provider.dart';
import 'package:two/services/email_verification_service.dart';
import 'email_step.dart';
import 'password_step.dart';
import 'verification_step.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _email = '';

  void _goToNextPage() async {
    if (_currentPage == 0) {
      // Página de email, apenas salva o email
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      _email = loginProvider.email ?? '';
    }
    if (_currentPage == 1) {
      // Só envia o código se a senha estiver correta
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final success = await loginProvider.login();
      if (!success) {
        if (loginProvider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loginProvider.errorMessage!)),
          );
        }
        return;
      }
      final sent = await EmailVerificationService.sendCode(_email);
      if (!sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao enviar código de verificação.')),
        );
        return;
      }
    }
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/pre-login');
    }
  }

  Widget _buildAppBarSteps() {
    final List<IconData> icons = [
      Icons.email_outlined,
      Icons.lock,
      Icons.verified_user_rounded,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(icons.length, (index) {
        final bool isCurrent = _currentPage == index;
        final bool isCompleted = _currentPage > index;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: isCurrent
              ? Icon(
                  icons[index],
                  color: AppColors.indexAtual,
                  size: 24,
                )
              : Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.indexCheck
                        : AppColors.indexDefault,
                    shape: BoxShape.circle,
                  ),
                ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.icons,
          ),
          onPressed: _goToPreviousPage,
        ),
        title: _buildAppBarSteps(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.icons),
            onPressed: () {
              Navigator.pushNamed(context, '/help-login');
            },
          ),
        ],
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.005),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [
            EmailStep(onNext: _goToNextPage),
            PasswordStep(onNext: _goToNextPage),
            VerificationStep(
              onComplete: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
              email: _email,
            ),
          ],
        ),
      ),
    );
  }
}
