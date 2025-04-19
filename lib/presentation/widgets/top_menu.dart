import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/base_screen.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(context, Icons.remove_red_eye_outlined, "Memórias", 0),
          _buildIcon(context, Icons.widgets_outlined, "Atividades", 1),
          _buildIcon(context, Icons.edit_calendar_rounded, "Planner do Casal", 2),
          _buildIcon(context, Icons.settings_outlined, "Configurações", 3),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon, String label, int page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BaseScreen(initialPage: page)),
        );
      },
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.icons),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: AppColors.titlePrimary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
