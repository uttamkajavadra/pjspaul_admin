import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/route/app_routes.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginForm = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obsurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Side - Branding (Hidden on mobile)
          if (MediaQuery.of(context).size.width > 900)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1507692049790-de58293a4697?q=80&w=2940&auto=format&fit=crop"), // Placeholder high-quality abstract image or church image
                    fit: BoxFit.cover,
                    opacity: 0.8,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "PJS Paul Ministries",
                        style: AppTheme.displayMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "\"For I am not ashamed of the gospel, because it is the power of God that brings salvation to everyone who believes.\"\n- Romans 1:16",
                        style: AppTheme.titleMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),

          // Right Side - Login Form
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Form(
                  key: loginForm,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mobile Logo
                      if (MediaQuery.of(context).size.width <= 900) ...[
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 32),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings_rounded,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],

                      Text(
                        "Welcome Back",
                        style: AppTheme.displaySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please sign in to your dashboard.",
                        style: AppTheme.bodyLarge
                            .copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 48),

                      _buildTextFieldLabel("Email Address"),
                      TextFormField(
                        controller: usernameController,
                        validator: (value) =>
                            Validator.validateNull("Username", value),
                        style: const TextStyle(fontSize: 16),
                        decoration: _inputDecoration("Enter your email"),
                      ),
                      const SizedBox(height: 24),

                      _buildTextFieldLabel("Password"),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obsurePassword,
                        validator: (value) =>
                            Validator.validateNull("Password", value),
                        style: const TextStyle(fontSize: 16),
                        decoration:
                            _inputDecoration("Enter your password").copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obsurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obsurePassword = !_obsurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          child: const Text("Sign In"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.errorColor.withOpacity(0.5)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
      ),
    );
  }

  void _handleLogin() {
    if (loginForm.currentState!.validate()) {
      if (usernameController.text == "pjspaulministry@gmail.com" &&
          passwordController.text == "PjsP@u1") {
        Get.offAllNamed(AppRoutes.main); // Use offAllNamed to clear stack
      } else {
        Get.snackbar(
          "Access Denied",
          "Invalid email or password provided.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.errorColor,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(24),
          icon: const Icon(Icons.error_outline, color: Colors.white),
          duration: const Duration(seconds: 4),
          maxWidth: 400,
        );
      }
    }
  }
}
