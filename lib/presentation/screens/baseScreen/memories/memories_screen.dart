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

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  _MemoriesScreenState createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  List<MemoryPost> posts = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  title: post.title,
                  date: post.date,
                  description: post.description,
                  imageUrl: post.imageUrl,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void addMemoryPost(String title, String description, String imageUrl) {
    setState(() {
      posts.add(MemoryPost(
        title: title,
        description: description,
        imageUrl: imageUrl,
        date: DateTime.now().toString(),
      ));
    });
  }
}

class MemoryPost {
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  MemoryPost({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });
}

class MemoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imageUrl;

  const MemoryCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  bool get isLocalFile => !imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final imageWidget = isLocalFile
        ? Image.file(
            File(imageUrl),
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
            imageUrl: imageUrl,
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
                                  ? FileImage(File(imageUrl)) as ImageProvider<Object>
                                  : CachedNetworkImageProvider(imageUrl) as ImageProvider<Object>,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.titleTerciary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.titleTerciary,
                            fontWeight: FontWeight.w500,
                          ),
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

void openAddMemoryModal(BuildContext context, Function(String, String, String) addMemoryPost) {
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
                  CustomInput(controller: descriptionController, maxLines: 5, labelText: 'Descrição'),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final status = await Permission.photos.request();

                      if (status.isGranted) {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setModalState(() {
                            imageUrl = pickedFile.path;
                          });
                        }
                      } else if (status.isPermanentlyDenied) {
                        openAppSettings();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Permissão para acessar a galeria negada.')),
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
                        addMemoryPost(titleController.text, descriptionController.text, imageUrl);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Preencha todos os campos e selecione uma imagem.')),
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
