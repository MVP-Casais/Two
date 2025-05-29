import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationStep extends StatefulWidget {
  final VoidCallback onComplete;
  final String email;

  const VerificationStep({super.key, required this.onComplete, required this.email});

  @override
  State<VerificationStep> createState() => _VerificationStepState();
}

class _VerificationStepState extends State<VerificationStep> {
  final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  bool isLoading = false;

  Future<bool> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/email-verification/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );
      if (response.statusCode == 200 && jsonDecode(response.body)['verified'] == true) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> resendCode() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/email-verification/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código reenviado para o e-mail.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao reenviar código.')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão ao reenviar código.')),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Insira o código",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "O código foi enviado para o seu email: ${widget.email}",
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: AppColors.textSecondarydark,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Container(
                  width: screenHeight * 0.07,
                  height: screenHeight * 0.10,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 45,
                        color: AppColors.titlePrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextButton(
              onPressed: isLoading ? null : resendCode,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      "Reenviar código",
                      style: TextStyle(
                        color: AppColors.titlePrimary,
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              text: "Entrar",
              onPressed: () async {
                final code = controllers.map((c) => c.text).join();
                if (code.length != 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite o código completo.')),
                  );
                  return;
                }
                setState(() => isLoading = true);
                final ok = await verifyCode(widget.email, code);
                setState(() => isLoading = false);
                if (ok) {
                  widget.onComplete();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código inválido.')),
                  );
                }
              },
              backgroundColor: AppColors.primary,
              textColor: AppColors.neutral,
            ),
          ],
        ),
      ),
    );
  }
}
