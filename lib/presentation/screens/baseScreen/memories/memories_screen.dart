import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: 20), 
          _buildMemoryContainer(),
        ],
      ),
    );
  }

  Widget _buildMemoryContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), 
        child: Container(
          height: 350, 
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Stack(
            children: [
             
              Positioned(
                top: -30, 
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/fundoMemorias.svg', 
                  fit: BoxFit.cover,
                ),
              ),
             
              Positioned(
                top: 50, 
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset(
                      'assets/images/casalMaos.svg', 
                      fit: BoxFit.contain, 
                    ),
                  ),
                ),
              ),
              
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Um símbolo eterno de amor e compromisso.', 
                    style: TextStyle(
                      color: AppColors.titleSecondary,
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}