import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double iconSize = size.width * 0.07;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajuda',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: AppColors.titlePrimary,
          ),
        ),
        centerTitle: true,
        leading: _currentPage == 0
            ? IconButton(
                icon: Icon(CupertinoIcons.back, size: iconSize),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              )
            : IconButton(
                icon: Icon(CupertinoIcons.back, size: iconSize),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    _currentPage = 0;
                  });
                },
              ),
        foregroundColor: AppColors.titlePrimary,
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: SizedBox.expand(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildTutorialContent(context),
                _buildFunction1Content(context),
                _buildFunction2Content(context),
                _buildFunction3Content(context),
                _buildFunction4Content(context),
                _buildFunction5Content(context),
              ],
            ),
            Positioned(
              bottom: size.height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: _CustomPageIndicator(
                  currentPage: _currentPage,
                  pageCount: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/images/fundo.tutorial2.svg',
              width: size.width,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.04,
              right: size.width * 0.04,
              top: size.width * 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.07),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: Text(
                    'Vamos aprender as funções do TWO',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                  text: "Começar",
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      _currentPage = 1;
                    });
                  },
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              'assets/images/boneco.tutorial.svg',
              height: size.height * 0.35,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunction1Content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                'Memórias',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Text(
                  'O app conta com uma seção especial onde você pode guardar memórias importantes, registrando momentos que deseja lembrar para sempre.',
                  style: TextStyle(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.normal,
                    color: AppColors.titlePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            'assets/images/fundo.tutorial.svg',
            width: size.width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Positioned(
          top: size.height * 0.23,
          left: 0,
          right: 0,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/camera.svg',
              height: size.height * 0.35,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunction2Content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                'Atividades',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Text(
                  'O app traz uma seção com diversas atividades pensadas para casais se conectarem de verdade, aproveitando momentos juntos longe do celular.',
                  style: TextStyle(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.normal,
                    color: AppColors.titlePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            'assets/images/fundo.tutorial2.svg',
            width: size.width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Positioned(
          top: size.height * 0.28,
          left: 0,
          right: -10,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/pag.atividades.svg',
              height: size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunction3Content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                'Planner',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Text(
                  'No planner do casal, vocês podem marcar datas especiais no calendário, como passeios, encontros e momentos importantes, facilitando a organização da rotina a dois.',
                  style: TextStyle(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.normal,
                    color: AppColors.titlePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            'assets/images/fundo.tutorial.svg',
            width: size.width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Positioned(
          top: size.height * 0.32,
          left: 0,
          right: 0,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/pag.planner.svg',
              height: size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunction4Content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                'Presença Real',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Text(
                  'Na função de Presença Real, o casal define um tempo para deixar o celular de lado e aproveitar um momento de qualidade juntos, com foco total um no outro.',
                  style: TextStyle(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.normal,
                    color: AppColors.titlePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            'assets/images/fundo.tutorial2.svg',
            width: size.width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Positioned(
          top: size.height * 0.29,
          left: size.width * 0.13,
          right: 0,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/pag.presenca.svg',
              height: size.height * 0.33,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunction5Content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                'Relatório Semanal',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Text(
                  'O app também conta com um relatório semanal que mostra os dias em que o casal esteve mais conectado, ajudando a acompanhar e valorizar esses momentos especiais juntos.',
                  style: TextStyle(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.normal,
                    color: AppColors.titlePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SvgPicture.asset(
            'assets/images/fundo.tutorial.svg',
            width: size.width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Positioned(
          top: size.height * 0.22,
          left: size.width * 0.05,
          right: 0,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/pag.relatorio.svg',
              height: size.height * 0.33,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const _CustomPageIndicator({
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final bool isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 18 : 13,
          height: 10,
          decoration: BoxDecoration(
            color: isActive
                ? (currentPage == 0 ? Colors.red : AppColors.primary)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey.shade300,
              width: 1,
            ),
          ),
        );
      }),
    );
  }
}

