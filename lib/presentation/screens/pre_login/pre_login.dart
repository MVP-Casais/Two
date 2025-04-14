import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_scaffold.dart';

class PreLoginPage extends StatelessWidget {
  const PreLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomScaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/LogoTwo.svg',
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Preparem-se para momentos incríveis, longe das distrações das redes sociais e mergulhados no presente!",
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: AppColors.textSecondarydark,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Spacer(),
          CustomButton(
            text: "Entrar com Google",
            onPressed: () {
              // Implementar lógica de login com Google
            },
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
            icon: SvgPicture.asset(
              'assets/images/iconGoogle.svg',
              height: screenHeight * 0.025,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          CustomButton(
            text: "Entrar com E-mail",
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(
              Icons.email_outlined,
              color: AppColors.neutral,
              size: screenHeight * 0.03,
            ),
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              Expanded(
                child: Divider(color: AppColors.inputBorder, thickness: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "ou",
                  style: TextStyle(
                    color: AppColors.textSecondarylight,
                    fontSize: screenHeight * 0.018,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: AppColors.inputBorder, thickness: 1),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text(
              "Não tem conta? Crie sua conta",
              style: TextStyle(
                color: AppColors.titlePrimary,
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }
}
