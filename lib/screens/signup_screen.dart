import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/signin_screen.dart';
import 'package:todo_app/secvices/auth_service.dart';
import 'package:todo_app/widgets/custom_textfield.dart';
import 'package:todo_app/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
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
                'Create your profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              CustomTextfield(label: 'Name', controller: _nameController),
              const SizedBox(height: 20),
              CustomTextfield(
                  label: 'Phone number', controller: _phoneController),
              const SizedBox(height: 20),
              CustomTextfield(label: 'Email', controller: _emailController),
              const SizedBox(height: 20),
              CustomTextfield(label: 'Password', controller: _pwdController),
              const SizedBox(height: 20),
              CustomTextfield(label: 'City', controller: _cityController),
              const SizedBox(height: 20),
              CustomTextfield(label: 'Pincode', controller: _pincodeController),
              const SizedBox(height: 50),
              PrimaryButton(
                onTap: () async {
                  setState(() {
                    showLoader = true;
                  });
                  try {
                    final AuthService authService = AuthService();
                    await authService.signupUser(
                      email: _emailController.text,
                      password: _pwdController.text,
                      name: _nameController.text,
                      phoneNumber: _phoneController.text,
                      city: _cityController.text,
                      pinCode: _pincodeController.text,
                    );
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
                label: 'Sign Up',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Alredy have an Account? ",
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
                              builder: (builder) => const SigninScreen()),
                          (route) => false);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
