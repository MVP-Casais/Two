import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart'; // Certifique-se de que a cor esteja definida lá

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
      backgroundColor: AppColors.background, // Usando a mesma cor de fundo das outras telas
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios, size: 20), // Ícone da seta como nas outras telas
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
              ),
              const Divider(),

              // Profile section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300'), // imagem exemplo
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
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(120, 120, 120, 1)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Configurações do perfil
              buildSectionTitle('Configurações do perfil'),
              buildSettingsItem(Icons.person_outline, 'Informações pessoais'),
              buildSettingsItem(Icons.lock_outline, 'Senha e segurança'),
              buildSettingsItem(Icons.notifications_none, 'Preferências de notificações'),

              const SizedBox(height: 16),
              buildSectionTitle('Configurações compartilhadas'),
              buildSettingsItem(Icons.group_outlined, 'Informações da conexão'),

              const SizedBox(height: 16),
              buildSectionTitle('Outros'),
              buildSwitchItem(Icons.dark_mode_outlined, 'Tema noturno'),
              buildSettingsItem(Icons.email_outlined, 'Verificação de Email', subtitle: 'Verificado'),

              const SizedBox(height: 24),

              // Logout button
              Center(
                child: TextButton(
                  onPressed: () {
                    // ação de sair
                  },
                  child: const Text(
                    'Sair da conta',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para título de sessão
  Widget buildSectionTitle(String title) {
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

  // Widget para itens de configuração
  Widget buildSettingsItem(IconData icon, String title, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color.fromRGBO(120, 120, 120, 1)),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // Widget para item com switch (tema noturno)
  Widget buildSwitchItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            _isDarkMode = !_isDarkMode; // Alterna o estado
          });
        },
        child: Container(
          width: 40, // Define o tamanho do botão
          height: 20, // Define a altura do botão
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.black : Color.fromRGBO(195, 195, 195, 1), // Cor de fundo do botão
            borderRadius: BorderRadius.circular(15), // Borda arredondada
          ),
          child: Stack(
            children: [
              Positioned(
                left: _isDarkMode ? 21 : 2, // Ajusta a posição da bolinha
                top: 2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  width: 16, // Tamanho da bolinha
                  height: 16, // Tamanho da bolinha
                  decoration: BoxDecoration(
                    color: Colors.white, // Bolinha branca
                    shape: BoxShape.circle, // Forma circular
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

