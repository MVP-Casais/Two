import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/activities/activities_screen.dart';
import 'package:two/presentation/screens/baseScreen/memories/memories_screen.dart';
import 'package:two/presentation/screens/baseScreen/planner/planner_screen.dart';
import 'package:two/presentation/screens/baseScreen/settings/settings_screen.dart';
import 'package:two/presentation/widgets/top_header.dart';

class BaseScreen extends StatefulWidget {
  final int initialPage;

  const BaseScreen({super.key, this.initialPage = 0});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    currentIndex = widget.initialPage;
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const TopHeader(
            useSliver: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconWithLabel(
                    icon: Icons.remove_red_eye_outlined,
                    label: "Memórias",
                    isSelected: currentIndex == 0,
                    onTap: () => onTabTapped(0),
                  ),
                  _buildIconWithLabel(
                    icon: Icons.widgets_outlined,
                    label: "Atividades",
                    isSelected: currentIndex == 1,
                    onTap: () => onTabTapped(1),
                  ),
                  _buildIconWithLabel(
                    icon: Icons.edit_calendar_rounded,
                    label: "Planner do Casal",
                    isSelected: currentIndex == 2,
                    onTap: () => onTabTapped(2),
                  ),
                  _buildIconWithLabel(
                    icon: Icons.settings_outlined,
                    label: "Configurações",
                    isSelected: currentIndex == 3,
                    onTap: () => onTabTapped(3),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const [
                MemoriesScreen(),
                ActivitiesScreen(),
                PlannerScreen(),
                SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithLabel({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.icons),
          const SizedBox(height: 5),
          Container(
            decoration: isSelected
                ? const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.titleSecondary,
                        width: 2.0,
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
