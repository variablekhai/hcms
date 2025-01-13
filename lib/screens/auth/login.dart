import 'package:flutter/material.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/screens/auth/register.dart';
import 'package:hcms/screens/cleaner/cleaner_jobs.dart';
import 'package:hcms/screens/report/cleaner_dashboard.dart';
import 'package:hcms/widgets/bottomNavigationMenu.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Text controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Password visibility toggle
  bool _isPasswordVisible = false;

  Map<String, String>? _authenticateUser(String email, String password) {
    for (var user in UserController().dummyUsers) {
      if (user['email'] == email && user['password'] == password) {
        return {
          'id': user['id']!,
          'name': user['name']!,
          'email': user['email']!,
          'role': user['role']!,
        }; // Return a map with id, email, and role if credentials match
      }
    }
    return {}; // Return null if no match is found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),

                // Logo
                const FlutterLogo(
                  size: 120,
                  style: FlutterLogoStyle.markOnly,
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 20),

                // Email TextField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),

                // Password TextField
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: _validatePassword,
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login'),
                ),

                const SizedBox(height: 20),

                // Register Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: Text(
                        'Register here',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
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
    );
  }

  // Validation Methods
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // Add more email validation logic
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Login Handler (Placeholder)
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {

      String email = _emailController.text;
      String password = _passwordController.text;

      final user = _authenticateUser(
        email,
        password,
      );

      if (user != null && user['role'] != null) {
        UserController().setUser(user['id']!, user['name']!, user['email']!, user['role']!);
        _navigateToUserScreen();
      }
    }
  }

  // Navigation to Specific User Screens
  void _navigateToUserScreen() {
    final user = UserController().currentUser;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            // Determine screen based on user type
            user?.role! == 'house_owner' ? BottomNavigationMenu() : CleanerDashboard()));
  }

  void _navigateToRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
