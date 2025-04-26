import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class TopHeader extends StatelessWidget {
  final bool useSliver;

  const TopHeader({super.key, this.useSliver = false});

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        SvgPicture.asset('assets/images/TWO.svg', height: 24),
        IconButton(icon: const Icon(Icons.add), onPressed: () {}),
      ],
    );

    if (useSliver) {
      return SliverAppBar(
        floating: false,
        snap: false,
        expandedHeight: 60.0,
        backgroundColor: AppColors.background,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 40, left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              SvgPicture.asset('assets/images/TWO.svg', height: 24),
              IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 5, right: 5),
          child: content,
        ),
      );
    }
  }
}
