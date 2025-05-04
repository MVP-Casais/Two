import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/base_screen.dart';

class TopMenu extends StatelessWidget {
  final int? currentIndex;
  final Function(int)? onTap;
  final bool navigateToBaseScreen;

  const TopMenu({
    super.key,
    this.currentIndex,
    this.onTap,
    this.navigateToBaseScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(context, 0, Icons.remove_red_eye_outlined, "Memórias"),
          _buildIcon(context, 1, Icons.widgets_outlined, "Atividades"),
          _buildIcon(
            context,
            2,
            Icons.calendar_month_outlined,
            "Planner do Casal",
          ),
          _buildIcon(context, 3, Icons.timer_outlined, "Presença Real"),
        ],
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = index == currentIndex;

    final selectedIcons = {
      0: Icons.visibility, 
      1: Icons.widgets, 
      2: Icons.calendar_month, 
      3: Icons.timer_rounded, 
    };

    return GestureDetector(
      onTap: () {
        if (navigateToBaseScreen) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BaseScreen(initialPage: index)),
          );
        } else {
          onTap?.call(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcons[index] ?? icon : icon, 
            size: 28,
            color: AppColors.icons,
          ),
          const SizedBox(height: 5),
          Container(
            decoration:
                isSelected
                    ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.titleSecondary,
                          width: 2,
                        ),
                      ),
                    )
                    : null,
            padding: const EdgeInsets.only(bottom: 4),
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
