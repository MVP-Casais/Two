import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Map<String, bool> _notificationStates = {
    'Ativar todas as notificações': true,
    'Lembretes de eventos do planner': true,
    'Solicitações de conexão de parceiro': false,
    'Interações do parceiro': false,
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.icons),
          ),
          centerTitle: true,
          title: const Text(
            'Preferências de notificações',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenWidth * 0.1),
            _buildSectionTitle('Geral'),
            _buildNotificationItem(
              'Ativar todas as notificações',
              'Ative ou desative todas as notificações do app. Se desativado, você não receberá alertas de eventos, mensagens ou atualizações',
            ),
            SizedBox(height: screenWidth * 0.1),
            _buildSectionTitle('Notificações Essenciais'),
            _buildNotificationItem(
              'Lembretes de eventos do planner',
              'Receba alertas sobre eventos e compromissos adicionados ao planner',
            ),
            _buildNotificationItem(
              'Solicitações de conexão de parceiro',
              'Será notificado se alguém enviar um pedido para se conectar com você',
            ),
            _buildNotificationItem(
              'Interações do parceiro',
              'Saiba quando seu parceiro interage com seus eventos',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondarylight,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.titlePrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondarylight,
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            _notificationStates[title] = !_notificationStates[title]!;
          });
        },
        child: Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.06,
          decoration: BoxDecoration(
            color: _notificationStates[title]! ? AppColors.primary : AppColors.placeholder,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _notificationStates[title]! ? screenWidth * 0.07 : screenWidth * 0.01,
                top: screenWidth * 0.01,
                child: Container(
                  width: screenWidth * 0.04,
                  height: screenWidth * 0.04,
                  decoration: BoxDecoration(
                    color: AppColors.neutral,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
