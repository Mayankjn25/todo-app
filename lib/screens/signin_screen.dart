import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/signup_screen.dart';
import 'package:todo_app/secvices/auth_service.dart';
import 'package:todo_app/widgets/custom_textfield.dart';
import 'package:todo_app/widgets/primary_button.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Todo App',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 150),
              const Text(
                'Login to continue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),
              CustomTextfield(
                  label: 'Enter email', controller: _emailController),
              const SizedBox(height: 30),
              CustomTextfield(
                label: 'Enter password',
                controller: _pwdController,
                obscureText: true,
              ),
              const SizedBox(height: 80),
              PrimaryButton(
                onTap: () async {
                  setState(() {
                    showLoader = true;
                  });
                  try {
                    final AuthService authService = AuthService();
                    await authService.loginUser(email: _emailController.text, password: _pwdController.text);
                    setState(() {
                      showLoader = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => HomeScreen()),
                            (route) => false);
                  } catch (e) {
                    final snackBar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      showLoader = false;
                    });
                  }
                },
                showLoader: showLoader,
                label: 'Login',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const SignupScreen()),
                          (route) => false);
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
