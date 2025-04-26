import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/activities/activities_screen.dart';
import 'package:two/presentation/screens/baseScreen/memories/memories_screen.dart';
import 'package:two/presentation/screens/baseScreen/settings/settings_screen.dart';
import 'package:two/presentation/screens/baseScreen/planner/planner_screen.dart'; // ✅ Corrigi a importação
import 'package:two/presentation/widgets/top_header.dart';
import 'package:two/presentation/widgets/navegation.dart';

class BaseScreen extends StatefulWidget {
  final int initialPage;

  const BaseScreen({super.key, this.initialPage = 0});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late PageController _pageController;
  int currentIndexTop = 0;
  int currentIndexBottom = -1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    currentIndexTop = widget.initialPage;
  }

  void onTabTappedNavigationTop(int indexTop) {
    _pageController.animateToPage(
      indexTop,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onTabTappedNavigationBottom(int indexBottom) {
    _pageController.animateToPage(
      indexBottom,
      duration: Duration(milliseconds: 300),
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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              TopHeader(useSliver: true),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconWithLabel(
                        icon: Icons.remove_red_eye_outlined,
                        label: "Memórias",
                        isSelected: currentIndexTop == 0,
                        onTap: () => onTabTappedNavigationTop(0),
                      ),
                      _buildIconWithLabel(
                        icon: Icons.widgets_outlined,
                        label: "Atividades",
                        isSelected: currentIndexTop == 1,
                        onTap: () => onTabTappedNavigationTop(1),
                      ),
                      _buildIconWithLabel(
                        icon: Icons.edit_calendar_rounded,
                        label: "Planner do Casal",
                        isSelected: currentIndexTop == 2,
                        onTap: () => onTabTappedNavigationTop(2),
                      ),
                      _buildIconWithLabel(
                        icon: Icons.settings_outlined,
                        label: "Configurações",
                        isSelected: currentIndexTop == 3,
                        onTap: () => onTabTappedNavigationTop(3),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (indexTop) {
                    setState(() {
                      currentIndexTop = indexTop;
                      currentIndexBottom = -1;
                    });
                  },
                  children: [
                    MemoriesScreen(),
                    ActivitiesScreen(),
                    PlannerScreen(), // ✅ Agora, PlannerScreen está referenciada corretamente
                    SettingsScreen(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            child: FloatingBottomNav(
              currentIndex: currentIndexBottom,
              onTap: (indexBottom) {
                setState(() {
                  currentIndexBottom = indexBottom;
                });
                onTabTappedNavigationBottom(indexBottom);
              },
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
          SizedBox(height: 5),
          Container(
            decoration: isSelected
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