import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/register/email_step.dart';
import 'package:two/presentation/screens/register/password_step.dart';
import 'package:two/presentation/screens/register/user_complete.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
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
      Icons.person_outline_sharp,
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
                    color: isCompleted ? AppColors.indexCheck : AppColors.indexDefault,
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
              Navigator.pushNamed(context, '/help-register'); 
            },
          ),
        ],
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005), 
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
            UserComplete(onComplete: () {
              Navigator.pushReplacementNamed(context, '/home');
            }),
          ],
        ),
      ),
    );
  }
}