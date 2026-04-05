import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/pages/funcationsPage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../data/constant/color.dart';
import '../../widgets/auth_text.dart';
import '../../widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful")),
      );


      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => HomePage()));

    } on FirebaseAuthException catch (e) {

      String message = "Login failed";

      if (e.code == 'user-not-found') {
        message = "Email not found";
      }

      if (e.code == 'wrong-password') {
        message = "Wrong password";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  /// LEFT SIDE (Animation)
                  if(size.width > 700)Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: Lottie.asset(
                          "json/login/lottieChart.json",
                          fit: BoxFit.contain,
                        ),
                      )
                    ),
                  ),

                  /// RIGHT SIDE (LOGIN)
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        margin: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              /// TITLE
                              Text(
                                'One ClinkZ',
                                style: TextStyle(
                                  fontFamily: "title",
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 32),

                              /// EMAIL
                              AuthTextField(
                                label: 'Username',
                                hint: 'username@gmail.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'error';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'error';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              /// PASSWORD
                              AuthTextField(
                                label: 'Password',
                                hint: "password",
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'error';
                                  }
                                  if (value.length < 6) {
                                    return 'error';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// FORGOT PASSWORD
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'forgot password',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              /// LOGIN BUTTON
                              PrimaryButton(
                                label: 'Login',
                                onPressed: _handleLogin,
                                isLoading: _isLoading,
                              ),

                              const SizedBox(height: 24),

                              /// REGISTER
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'New user ? ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
