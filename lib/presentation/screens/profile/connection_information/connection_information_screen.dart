import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/providers/connection_provider.dart';
import 'package:two/providers/ranking_provider.dart';
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
    final TextEditingController codeController = TextEditingController();
    ValueNotifier<bool> isLoading = ValueNotifier(false);
    ValueNotifier<String?> errorMessage = ValueNotifier(null);
    ValueNotifier<String?> generatedCode = ValueNotifier(null);

    Future<void> generateCode() async {
      isLoading.value = true;
      errorMessage.value = null;
      // Chame o backend para gerar um código de conexão (implemente no backend)
      final code = await ConnectionService.generateConnectionCode();
      if (code != null) {
        generatedCode.value = code;

        try {
          await Provider.of<RankingProvider>(context, listen: false).fetchRanking();
        } catch (_) {}
      } else {
        errorMessage.value = "Erro ao gerar código.";
      }
      isLoading.value = false;
    }

    Future<void> connectWithCode() async {
      final code = codeController.text.trim();
      if (code.length != 4) {
        errorMessage.value = "Digite o código de 4 dígitos.";
        return;
      }
      isLoading.value = true;
      errorMessage.value = null;
      final result = await provider.connectWithCode(code);
      isLoading.value = false;
      if (result != null) {
        errorMessage.value = result;
      } else {
        // NOVO: Atualiza ranking automaticamente após conectar
        try {
          await Provider.of<RankingProvider>(context, listen: false).fetchRanking();
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conexão realizada com sucesso!')),
        );
        codeController.clear();
      }
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
              // Opção 1: Gerar código
              CustomButton(
                backgroundColor: AppColors.primary,
                textColor: AppColors.neutral,
                text: isLoading.value ? 'Gerando...' : 'Gerar código para compartilhar',
                onPressed: isLoading.value
                    ? null
                    : () async {
                        await generateCode();
                      },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: generatedCode,
                builder: (context, code, _) {
                  if (code == null) return SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        Text(
                          "Compartilhe este código com seu parceiro:",
                          style: TextStyle(
                            color: AppColors.titlePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        SelectableText(
                          code,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 8,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 32),
              // Opção 2: Inserir código recebido
              Text(
                "Ou insira o código de 4 dígitos recebido do parceiro",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: codeController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Digite o código de 4 dígitos",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
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
                        text: loading ? 'Conectando...' : 'Conectar com código',
                        onPressed: loading
                            ? null
                            : () async {
                                await connectWithCode();
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
