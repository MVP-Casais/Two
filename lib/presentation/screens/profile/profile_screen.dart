import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/profile/connection_information/connection_information_screen.dart';
import 'package:two/presentation/screens/profile/information_profile/information_screen.dart';
import 'package:two/presentation/screens/profile/security/security_screen.dart';
import 'package:two/providers/profile_provider.dart';
import 'package:two/services/auth_service.dart';
import 'package:two/services/token_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;

  void carregarPerfil(BuildContext context) async {
    final response = await AuthService.getProfile();

    final profileProvider = context.read<ProfileProvider>();

    if (response['statusCode'] == 200) {
      final body = response['body'];

      profileProvider.setNome(body['nome']);
      profileProvider.setUsername(body['username']);
      profileProvider.setEmail(body['email']);
      profileProvider.setGenero(body['genero']);

      final imagemUrl = body['foto_perfil'] ?? body['image_url'];
      profileProvider.setImageUrl(imagemUrl ?? '');
    } else {
      profileProvider.reset();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      carregarPerfil(context);
    });
  }

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
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.08,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (profileProvider.imageUrl != null &&
                  profileProvider.imageUrl!.isNotEmpty) {
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
                              color:
                                  Colors.black.withAlpha((0.3 * 255).toInt()),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderNavigation,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            color: AppColors.neutral,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl: profileProvider.imageUrl!,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.7,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            child: _buildProfileImage(screenWidth, profileProvider.imageUrl),
          ),
          SizedBox(width: screenWidth * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileProvider.nome == null
                  ? CircularProgressIndicator()
                  : Text(
                      profileProvider.nome!,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              SizedBox(height: screenWidth * 0.01),
              profileProvider.email == null
                  ? CircularProgressIndicator()
                  : Text(
                      profileProvider.email!,
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

  Widget _buildProfileImage(double screenWidth, String? imageUrl) {
    final double radius = screenWidth * 0.08;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: radius * 2,
            height: radius * 2,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            width: radius * 2,
            height: radius * 2,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: Icon(Icons.error, color: Colors.red, size: radius),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person, size: radius, color: Colors.white),
      );
    }
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
        onPressed: () async {
          await TokenService().clearToken(); 
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/pre-login', 
            (route) => false,
          );
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
