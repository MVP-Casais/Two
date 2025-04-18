import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentIndex = 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            snap: false,
            expandedHeight: 60.0,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: SvgPicture.asset('assets/images/TWO.svg', height: 16),
            ),
            leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconWithLabel(
                      icon: Icons.remove_red_eye_outlined,
                      label: "Memórias",
                      isSelected: currentIndex == 0,
                    ),
                    _buildIconWithLabel(
                      icon: Icons.widgets_outlined,
                      label: "Atividades",
                      isSelected: currentIndex == 1,
                    ),
                    _buildIconWithLabel(
                      icon: Icons.edit_calendar_rounded,
                      label: "Planner do Casal",
                      isSelected: currentIndex == 2,
                    ),
                    _buildIconWithLabel(
                      icon: Icons.settings_outlined,
                      label: "Configurações",
                      isSelected: currentIndex == 3,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithLabel({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.icons),
          SizedBox(height: 5),
          Container(
            decoration:
                isSelected
                    ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.titleSecondary,
                          width: 2.0,
                        ),
                      ),
                    )
                    : null,
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.titlePrimary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
