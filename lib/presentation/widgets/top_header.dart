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
      children: [
        IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        SvgPicture.asset('assets/images/TWO.svg', height: 16),
        IconButton(icon: const Icon(Icons.add), onPressed: () {}),
      ],
    );

    if (useSliver) {
      return SliverAppBar(
        floating: false,
        snap: false,
        expandedHeight: 60.0,
        backgroundColor: AppColors.background,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: SvgPicture.asset('assets/images/TWO.svg', height: 16),
        ),
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      );
    } else {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: content,
        ),
      );
    }
  }
}
