import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';

class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = [
      _NavItem(icon: Icons.home_filled, label: "Home"),
      _NavItem(icon: Icons.emoji_events, label: "Ranking"),
      _NavItem(icon: Icons.person, label: "Perfil"),
    ];

    final double width = MediaQuery.of(context).size.width * 0.55;
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5), 
          decoration: BoxDecoration(
            color: AppColors.neutral,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColors.borderNavigation,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withAlpha((0.2 * 255).toInt()),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final bool isSelected = index == currentIndex;

              return Expanded( 
                child: GestureDetector(
                  onTap: () {
                    onTap(index);
                    if (index != currentIndex) { 
                      switch (index) {
                        case 0:
                          Navigator.pushReplacementNamed(context, '/home');
                          break;
                        case 1:
                          Navigator.pushReplacementNamed(context, '/ranking');
                          break;
                        case 2:
                          Navigator.pushReplacementNamed(context, '/profile');
                          break;
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.indicatorBackground : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: isSelected ? 10 : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[index].icon,
                          color: isSelected ? AppColors.neutral : AppColors.indicatorBackground,
                          size: 25,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          items[index].label,
                          style: TextStyle(
                            color: isSelected ? AppColors.neutral : AppColors.indicatorBackground,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
