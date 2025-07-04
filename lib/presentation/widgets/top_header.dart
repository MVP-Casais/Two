import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class TopHeader extends StatelessWidget {
  final bool useSliver;
  final VoidCallback? onAddEvent;
  final bool showAddIcon;
  final Color? addIconColor; // NOVO

  const TopHeader({
    super.key,
    this.useSliver = false,
    this.onAddEvent,
    this.showAddIcon = true,
    this.addIconColor, // NOVO
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final content = Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/TWO.svg',
          height: screenHeight * 0.03,
        ),
        if (showAddIcon)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: screenHeight * 0.03,
                color: addIconColor ?? AppColors.placeholder, // NOVO
              ),
              onPressed: onAddEvent,
              disabledColor: (addIconColor ?? AppColors.icons).withOpacity(0.4), // NOVO
            ),
          ),
      ],
    );

    if (useSliver) {
      return SliverAppBar(
        floating: false,
        snap: false,
        expandedHeight: screenHeight * 0.08,
        backgroundColor: AppColors.background,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.05,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
          ),
          child: content,
        ),
      );
    } else {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenHeight * 0.01,
          ),
          child: content,
        ),
      );
    }
  }
}
