import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:two/providers/memories_provider.dart';
import 'package:two/providers/connection_provider.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  _MemoriesScreenState createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Garante que a conexão está restaurada antes de buscar memórias
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);
      await connectionProvider.restoreConnection();
      await Provider.of<MemoriesProvider>(context, listen: false)
          .fetchMemories();
      if (mounted) setState(() {});
    });
  }

  void _editMemory(MemoryPost post) {
    TextEditingController titleController =
        TextEditingController(text: post.title);
    TextEditingController descriptionController =
        TextEditingController(text: post.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Editar Memória',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titlePrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomInput(
                        controller: titleController, labelText: 'Título'),
                    const SizedBox(height: 16),
                    CustomInput(
                        controller: descriptionController,
                        maxLines: 5,
                        labelText: 'Descrição'),
                    const Spacer(),
                    CustomButton(
                      text: 'Salvar',
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.neutral,
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty) {
                          final provider = Provider.of<MemoriesProvider>(
                              context,
                              listen: false);
                          final success = await provider.editMemory(
                            post: post,
                            title: titleController.text,
                            description: descriptionController.text,
                          );
                          Navigator.pop(context);
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Erro ao editar memória.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Preencha todos os campos.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteMemory(MemoryPost post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Excluir memória',
          style: TextStyle(
              color: AppColors.titlePrimary, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        content: const Text('Tem certeza que deseja excluir esta memória?'),
        actions: [
          CustomButton(
              text: "Excluir",
              backgroundColor: AppColors.primary,
              textColor: AppColors.neutral,
              onPressed: () => Navigator.pop(context, true)),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Cancelar',
            backgroundColor: AppColors.borderNavigation,
            textColor: AppColors.titlePrimary,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final provider = Provider.of<MemoriesProvider>(context, listen: false);
      final success = await provider.deleteMemory(post: post);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir memória.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final posts = Provider.of<MemoriesProvider>(context).memories;
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final isConnected = connectionProvider.isConnected;

    if (!isConnected) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Você precisa conectar com seu parceiro(a) para usar as Memórias.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Conectar com parceiro(a)',
                  onPressed: () {
                    Navigator.pushNamed(context, '/connection');
                  },
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              children: posts.map((post) {
                return MemoryCard(
                  post: post,
                  onEdit: () => _editMemory(post),
                  onDelete: () => _deleteMemory(post),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final MemoryPost post;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MemoryCard({
    super.key,
    required this.post,
    this.onEdit,
    this.onDelete,
  });

  bool get isLocalFile => !post.imageUrl.startsWith('http');

  String get formattedDate {
    try {
      final dt = DateTime.parse(post.date);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return post.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final imageWidget = isLocalFile
        ? Image.file(
            File(post.imageUrl),
            height: screenHeight * 0.3,
            width: screenWidth,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: screenHeight * 0.3,
              color: AppColors.loadingBackground,
              child: const Icon(Icons.broken_image, size: 40),
            ),
          )
        : CachedNetworkImage(
            imageUrl: post.imageUrl,
            height: screenHeight * 0.3,
            width: screenWidth,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: screenHeight * 0.3,
              color: AppColors.loadingBackground,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.loadingIndicator,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: screenHeight * 0.3,
              color: AppColors.loadingBackground,
              child: const Icon(Icons.broken_image, size: 40),
            ),
          );

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.025),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/fundoMemorias.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.black,
                          insetPadding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: PhotoView(
                              imageProvider: isLocalFile
                                  ? FileImage(File(post.imageUrl))
                                      as ImageProvider<Object>
                                  : CachedNetworkImageProvider(post.imageUrl)
                                      as ImageProvider<Object>,
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                            ),
                          ),
                        ),
                      );
                    },
                    child: imageWidget,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleSecondary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.titleTerciary,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                post.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.titleTerciary,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz,
                              size: 30, color: AppColors.icons),
                          onSelected: (value) {
                            if (value == 'Editar') {
                              if (onEdit != null) onEdit!();
                            } else if (value == 'Excluir') {
                              if (onDelete != null) onDelete!();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'Editar',
                              child: Text('Editar'),
                            ),
                            const PopupMenuItem(
                              value: 'Excluir',
                              child: Text('Excluir'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void openAddMemoryModal(
    BuildContext context, Function(String, String, String) addMemoryPost) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String imageUrl = '';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Adicionar Memória',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titlePrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomInput(controller: titleController, labelText: 'Título'),
                  const SizedBox(height: 16),
                  CustomInput(
                      controller: descriptionController,
                      maxLines: 5,
                      labelText: 'Descrição'),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final status = await Permission.photos.request();

                      if (status.isGranted) {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setModalState(() {
                            imageUrl = pickedFile.path;
                          });
                        }
                      } else if (status.isPermanentlyDenied) {
                        openAppSettings();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Permissão para acessar a galeria negada.')),
                        );
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: AppColors.icons,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'Adicionar',
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.neutral,
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          imageUrl.isNotEmpty) {
                        addMemoryPost(titleController.text,
                            descriptionController.text, imageUrl);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Preencha todos os campos e selecione uma imagem.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
