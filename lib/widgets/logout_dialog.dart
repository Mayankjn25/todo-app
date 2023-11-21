import 'package:flutter/material.dart';
import 'package:todo_app/screens/signin_screen.dart';
import 'package:todo_app/secvices/auth_service.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Logout',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: const SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
               Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 14),
              ),
               SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            AuthService authService = AuthService();
            await authService.logout();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => const SigninScreen()),
                    (route) => false);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
