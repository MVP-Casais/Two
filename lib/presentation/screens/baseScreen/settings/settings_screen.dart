import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/home/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false; // Estado para alternar o modo noturno

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
              const Divider(),
              _buildProfileSection(),
              const Divider(),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Icon(Icons.arrow_back_ios, size: 20),
          ),
        ),
        const Center(
          child: Text(
            'Configurações',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Two Exemplo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'email@exemplo.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(120, 120, 120, 1),
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
        _buildSettingsItem(Icons.person_outline, 'Informações pessoais'),
        _buildSettingsItem(Icons.lock_outline, 'Senha e segurança'),
        _buildSettingsItem(Icons.notifications_none, 'Preferências de notificações'),
        const SizedBox(height: 16),
        _buildSectionTitle('Configurações compartilhadas'),
        _buildSettingsItem(Icons.group_outlined, 'Informações da conexão'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromRGBO(120, 120, 120, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(120, 120, 120, 1),
              ),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _buildSwitchItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
        child: Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            color: _isDarkMode
                ? Colors.black
                : const Color.fromRGBO(195, 195, 195, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _isDarkMode ? 21 : 2,
                top: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.white,
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
    return Center(
      child: TextButton(
        onPressed: () {
          // ação de logout
        },
        child: const Text(
          'Sair da conta',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
