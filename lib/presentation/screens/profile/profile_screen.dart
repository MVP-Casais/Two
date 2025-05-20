import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/profile/connection_information/connection_information_screen.dart';
import 'package:two/presentation/screens/profile/information_profile/information_screen.dart';
import 'package:two/presentation/screens/profile/notification/notification_screen.dart';
import 'package:two/presentation/screens/profile/security/security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              _buildProfileSection(),
              _buildSettingsSections(),
              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Icon(Icons.arrow_back_ios, size: 20),
            ),
          ),
          const Center(
            child: Text(
              'Perfil',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.08,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.3 * 255).toInt()),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            width: 6,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            'https://i.pravatar.cc/300',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: screenWidth * 0.08,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/300'),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two Exemplo',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                'email@exemplo.com',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.textSecondarylight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Configurações do perfil'),
        _buildSettingsItem(
          Icons.person_outline,
          'Informações pessoais',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InformationScreen(),
              ),
            );
          },
        ),
        _buildSettingsItem(
          Icons.lock_outline,
          'Senha e segurança',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecurityScreen()),
            );
          },
        ),
        _buildSettingsItem(
          Icons.notifications_none,
          'Preferências de notificações',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Configurações compartilhadas'),
        _buildSettingsItem(
          Icons.group_outlined,
          'Informações da conexão',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConnectionInformationScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Outros'),
        _buildSwitchItem(Icons.dark_mode_outlined, 'Tema noturno'),
        _buildSettingsItem(
          Icons.email_outlined,
          'Verificação de Email',
          subtitle: 'Verificado',
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.02,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          color: AppColors.textSecondarylight,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      leading: Icon(icon, color: AppColors.icons, size: screenWidth * 0.06),
      title: Text(title, style: TextStyle(fontSize: screenWidth * 0.04)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: AppColors.textSecondarylight,
              ),
            )
          : null,
      trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(IconData icon, String title) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isDarkMode = !_isDarkMode;
        });
      },
      child: ListTile(
        leading: Icon(icon, color: AppColors.icons, size: screenWidth * 0.06),
        title: Text(title, style: TextStyle(fontSize: screenWidth * 0.04)),
        trailing: Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.06,
          decoration: BoxDecoration(
            color: _isDarkMode ? AppColors.primary : AppColors.placeholder,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _isDarkMode ? screenWidth * 0.07 : screenWidth * 0.01,
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

  Widget _buildLogoutButton() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: TextButton(
        onPressed: () {
          // ação de logout
        },
        child: Text(
          'Sair da conta',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ),
    );
  }
}
