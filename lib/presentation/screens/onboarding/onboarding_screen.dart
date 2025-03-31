import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'package:two/core/themes/app_colors.dart';

const _animationDuration = Duration(milliseconds: 300);
const _indicatorMargin = EdgeInsets.symmetric(horizontal: 4);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Crie uma conexão especial com quem você ama",
      "subtitle":
          "Two ajuda vocês a se conectarem e fortalecerem o relacionamento",
      "image": "assets/images/onboarding1.svg",
    },
    {
      "title": "Planeje encontros, compartilhe fotos e registre memórias",
      "subtitle":
          "Tudo em um só lugar para deixar o relacionamento ainda mais especial",
      "image": "assets/images/onboarding2.svg",
    },
    {
      "title":
          "Divirta-se com desafios, perguntas e jogos exclusivos para casais",
      "subtitle": "Aproxime-se ainda mais enquanto se diverte",
      "image": "assets/images/onboarding3.svg",
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToNextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: _animationDuration,
        curve: Curves.ease,
      );
    } else {
      _skipOnboarding();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: _animationDuration,
        curve: Curves.ease,
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading:
            _currentPage > 0
                ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.icons,
                  ),
                  onPressed: _goToPreviousPage,
                  tooltip: 'Voltar',
                )
                : SizedBox.shrink(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            onboardingData.length,
            (index) => AnimatedContainer(
              duration: _animationDuration,
              margin: _indicatorMargin,
              width: _currentPage == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentPage == index
                        ? AppColors.primary
                        : AppColors.indicatorBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onboardingData.length,
                itemBuilder:
                    (context, index) => OnboardingPage(
                      key: ValueKey('onboarding_page_$index'),
                      title: onboardingData[index]["title"]!,
                      subtitle: onboardingData[index]["subtitle"]!,
                      image: onboardingData[index]["image"]!,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    text: _currentPage == onboardingData.length - 1 ? "Entrar" : "Próximo",
                    onPressed: _goToNextPage,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.neutral,
                  ),
                  if (_currentPage < onboardingData.length - 1) ...[
                    SizedBox(height: screenHeight * 0.015),
                    CustomButton(
                      text: "Pular",
                      onPressed: _skipOnboarding,
                      backgroundColor: AppColors.background,
                      textColor: AppColors.titlePrimary,
                      borderSide: BorderSide(color: AppColors.inputBorder),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final BorderSide? borderSide;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.textColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.055,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontSize: screenHeight * 0.02, 
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
