import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/activities/activities_screen.dart';
import 'package:two/presentation/screens/baseScreen/memories/memories_screen.dart';
import 'package:two/presentation/screens/baseScreen/presenceMode/presence_mode.dart';
import 'package:two/presentation/screens/baseScreen/planner/planner_screen.dart';
import 'package:two/presentation/widgets/top_header.dart';
import 'package:two/presentation/widgets/top_menu.dart';
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

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<PlannerScreenState> plannerScreenKey = GlobalKey(); // Corrige o tipo do estado

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    currentIndexTop = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onTabTappedNavigationTop(int indexTop) {
    _pageController.animateToPage(
      indexTop,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onTabTappedNavigationBottom(int indexBottom) {
    _pageController.animateToPage(
      indexBottom,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.background,
              expandedHeight: 146,
              floating: true,
              snap: false, 
              pinned: false,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none, 
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TopHeader(
                      useSliver: false,
                      showAddIcon: currentIndexTop == 2 || currentIndexTop == 0,
                      onAddEvent: () {
                        if (currentIndexTop == 2) {
                          plannerScreenKey.currentState?.openAddEventModal(context);
                        } else if (currentIndexTop == 0) {
                          openAddMemoryModal(context, (title, description, imageUrl) {
                            setState(() {
                            });
                          });
                        }
                      },
                    ),
                    TopMenu(
                      currentIndex: currentIndexTop,
                      onTap: (index) => onTabTappedNavigationTop(index),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (indexTop) {
                setState(() {
                  currentIndexTop = indexTop;
                  currentIndexBottom = -1;
                });
              },
              children: [
                const MemoriesScreen(),
                const ActivitiesScreen(),
                PlannerScreen(key: plannerScreenKey),
                PresenceModeScreen(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
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
      ),
    );
  }
}
