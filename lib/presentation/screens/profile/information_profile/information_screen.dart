import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/profile_provider.dart';
import 'package:two/services/profile_service.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final List<String> genders = ['Masculino', 'Feminino', 'Outro'];
  late TextEditingController nomeController;
  late TextEditingController usernameController;
  String? selectedGender;
  File? pickedImageFile;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController();
    usernameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);

      final profileResult = await ProfileService.fetchProfile();
      if (profileResult['statusCode'] == 200) {
        final data = profileResult['body'];
        profileProvider.setNome(data['nome']);
        profileProvider.setUsername(data['username']);
        profileProvider.setGenero(data['genero']);
        profileProvider.setEmail(data['email']);
        profileProvider.setImageUrl(data['foto_perfil']);
        updateProfileProvider.loadFromProfileProvider(profileProvider);
      }

      nomeController.text = updateProfileProvider.nome ?? '';
      usernameController.text = updateProfileProvider.username ?? '';
      selectedGender = updateProfileProvider.genero?.toLowerCase();

      nomeController.addListener(() {
        updateProfileProvider.setNome(nomeController.text);
      });
      usernameController.addListener(() {
        updateProfileProvider.setUsername(usernameController.text);
      });
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        pickedImageFile = File(pickedFile.path);
      });
      Provider.of<UpdateProfileProvider>(context, listen: false)
          .setImageUrl(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios,
                size: 20, color: AppColors.icons),
          ),
          centerTitle: true,
          title: const Text(
            'Informações Pessoais',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenWidth * 0.1),
                      GestureDetector(
                        onTap: () {
                          if (pickedImageFile != null || (updateProfileProvider.imageUrl != null && updateProfileProvider.imageUrl!.isNotEmpty)) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: pickedImageFile != null
                                          ? Image.file(pickedImageFile!)
                                          : Image.network(updateProfileProvider.imageUrl!),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: screenWidth * 0.15,
                          backgroundColor: AppColors.inputBorder,
                          child: ClipOval(
                            child: pickedImageFile != null
                                ? Image.file(
                                    pickedImageFile!,
                                    width: screenWidth * 0.3,
                                    height: screenWidth * 0.3,
                                    fit: BoxFit.cover,
                                  )
                                : (updateProfileProvider.imageUrl != null &&
                                        updateProfileProvider.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        updateProfileProvider.imageUrl!,
                                        width: screenWidth * 0.3,
                                        height: screenWidth * 0.3,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: screenWidth * 0.15,
                                            color: AppColors.neutral,
                                          );
                                        },
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: screenWidth * 0.15,
                                        color: AppColors.neutral,
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      CustomButton(
                        backgroundColor: AppColors.background,
                        textColor: AppColors.primary,
                        text: 'Alterar Foto',
                        onPressed: pickImage,
                      ),
                      SizedBox(height: screenWidth * 0.05),
                      _buildInputField(
                          'Nome', 'Digite seu nome', nomeController),
                      SizedBox(height: screenWidth * 0.05),
                      _buildInputField('Nome de Usuário',
                          'Digite seu nome de usuário', usernameController),
                      SizedBox(height: screenWidth * 0.05),
                      _buildGenderDropdown(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  bottom: screenWidth * 0.05),
              child: CustomButton(
                backgroundColor: AppColors.primary,
                textColor: AppColors.neutral,
                text: updateProfileProvider.status == Status.loading
                    ? 'Salvando...'
                    : 'Salvar Alterações',
                onPressed: updateProfileProvider.status == Status.loading
                    ? null
                    : () {
                        final nome = nomeController.text.trim();
                        final username = usernameController.text.trim();
                        final genero = selectedGender?.trim() ?? '';

                        if (nome.isEmpty || username.isEmpty || genero.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
                          );
                          return;
                        }

                        updateProfileProvider
                            .updateProfile(
                          nome: nome,
                          username: username,
                          genero: genero,
                          imageFile: pickedImageFile,
                        )
                            .then((success) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Perfil atualizado com sucesso!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(updateProfileProvider.errorMessage ?? 'Erro ao atualizar'),
                              ),
                            );
                          }
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.titlePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        CustomInput(
          controller: controller,
          labelText: hint,
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    final validSelectedGender = genders.map((g) => g.toLowerCase()).contains(selectedGender)
        ? selectedGender
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gênero',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.titlePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: validSelectedGender,
              hint: const Text('Selecione um gênero'),
              items: genders.map((String value) {
                return DropdownMenuItem<String>(
                  value: value.toLowerCase(),
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedGender = newValue;
                  });
                  Provider.of<UpdateProfileProvider>(context, listen: false)
                      .setGenero(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}