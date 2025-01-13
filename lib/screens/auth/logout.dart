import 'package:flutter/material.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/screens/auth/login.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            UserController().clearUser();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginView()));
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
