import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/providers/connection_provider.dart';
import 'package:two/services/connection_service.dart';

// Componente extra: Toggle Switch
class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: screenWidth * 0.12,
        height: screenWidth * 0.06,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.placeholder,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: value ? screenWidth * 0.07 : screenWidth * 0.01,
              top: screenWidth * 0.01,
              child: Container(
                width: screenWidth * 0.04,
                height: screenWidth * 0.04,
                decoration: const BoxDecoration(
                  color: AppColors.neutral,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionInformationScreen extends StatefulWidget {
  const ConnectionInformationScreen({super.key});

  @override
  State<ConnectionInformationScreen> createState() =>
      _ConnectionInformationScreenState();
}

class _ConnectionInformationScreenState
    extends State<ConnectionInformationScreen> {
  final TextEditingController usernameController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  @override
  void dispose() {
    usernameController.dispose();
    isLoading.dispose();
    errorMessage.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Restaura conexão imediatamente e notifica a tela assim que possível
    final provider = Provider.of<ConnectionProvider>(context, listen: false);
    provider.restoreConnection().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
      builder: (context, connectionProvider, _) {
        final isConnected = connectionProvider.isConnected;
        final partner = connectionProvider.partner;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: AppColors.icons, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Informações da Conexão',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: isConnected && partner != null
                ? _buildConnected(context, partner, connectionProvider)
                : _buildDisconnected(context, connectionProvider),
          ),
        );
      },
    );
  }

  Widget _buildConnected(
      BuildContext context, Partner partner, ConnectionProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.1),
        _buildSectionTitle('Conexão'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Parceiro Conectado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
          subtitle: Text(
            'Conexão atual com: ${partner.name} (@${partner.username})',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondarylight,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: AppColors.icons, size: 18),
            onPressed: () => _mostrarParceiroConectado(context, partner),
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Compartilhar Planner',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
          subtitle: const Text(
            'Sincronize eventos, lembretes e compromissos no calendário do casal',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondarylight,
            ),
          ),
          trailing: CustomToggleSwitch(
            value: provider.syncPlanner,
            onChanged: provider.setSyncPlanner,
          ),
        ),
        SizedBox(height: screenWidth * 0.3),
        Center(
          child: GestureDetector(
            onTap: () => _confirmarDesconexao(context, provider),
            child: const Text(
              'Desconectar do Parceiro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisconnected(BuildContext context, ConnectionProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController usernameController = TextEditingController();
    ValueNotifier<bool> isLoading = ValueNotifier(false);
    ValueNotifier<String?> errorMessage = ValueNotifier(null);
    ValueNotifier<List<String>> suggestions = ValueNotifier([]);

    Future<void> fetchSuggestions(String query) async {
      if (query.isEmpty) {
        suggestions.value = [];
        return;
      }
      isLoading.value = true;
      final result = await ConnectionService.searchUsernames(query);
      suggestions.value = result;
      isLoading.value = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.1),
        _buildSectionTitle('Conexão'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Nenhum parceiro conectado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
          subtitle: const Text(
            'Você ainda não está conectado a um parceiro.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondarylight,
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Pesquisar parceiro pelo username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Digite o username do parceiro",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(Icons.search, color: AppColors.icons),
                ),
                onChanged: (value) {
                  fetchSuggestions(value.trim());
                },
              ),
              ValueListenableBuilder<List<String>>(
                valueListenable: suggestions,
                builder: (context, list, _) {
                  if (list.isEmpty) return SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neutral,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, idx) {
                        return ListTile(
                          title: Text(list[idx]),
                          onTap: () {
                            usernameController.text = list[idx];
                            suggestions.value = [];
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, loading, _) {
                  return ValueListenableBuilder<String?>(
                    valueListenable: errorMessage,
                    builder: (context, error, _) {
                      return CustomButton(
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.neutral,
                        text: loading ? 'Enviando...' : 'Conectar Parceiro',
                        onPressed: loading
                            ? null
                            : () async {
                                final username = usernameController.text.trim();
                                if (username.isEmpty) {
                                  errorMessage.value =
                                      "Digite o username do parceiro.";
                                  return;
                                }
                                errorMessage.value = null;
                                isLoading.value = true;
                                final result = await provider
                                    .sendConnectionRequest(username);
                                isLoading.value = false;
                                if (result != null) {
                                  errorMessage.value = result;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Convite enviado com sucesso!')),
                                  );
                                  usernameController.clear();
                                }
                              },
                      );
                    },
                  );
                },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: errorMessage,
                builder: (context, error, _) {
                  if (error == null) return SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondarylight,
      ),
    );
  }

  void _mostrarParceiroConectado(BuildContext context, Partner partner) {
    final screenWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.background,
          child: SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Parceiro Conectado',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                  const SizedBox(height: 26),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(partner.avatarUrl ?? ""),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    partner.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@${partner.username}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondarylight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    backgroundColor: AppColors.primary,
                    text: 'Fechar',
                    textColor: AppColors.neutral,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmarDesconexao(
      BuildContext context, ConnectionProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Desconectar',
          style: TextStyle(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        content: const Text('Tem certeza que deseja desconectar do parceiro?'),
        actions: [
          CustomButton(
            text: "Desconectar",
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
            onPressed: () => Navigator.pop(context, true),
          ),
          SizedBox(height: 10,),
          CustomButton(
            text: "Cancelar",
            backgroundColor: AppColors.inputBackground,
            textColor: AppColors.titlePrimary,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );

    if (confirm == true) {
      provider.disconnect();
    }
  }
}
