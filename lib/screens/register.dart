import 'package:flutter/material.dart';
import 'package:hcms/screens/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// Enum for account types
enum AccountType {
  houseOwner,
  cleaner
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Account type selection
  AccountType _selectedAccountType = AccountType.houseOwner;

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
                const SizedBox(height: 80),
                
                // Logo
                FlutterLogo(
                  size: 120,
                  style: FlutterLogoStyle.markOnly,
                ),
                
                const SizedBox(height: 40),
                
                // Title
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                
                const SizedBox(height: 30),

                // Account Type Selection
                Text(
                  'Select Account Type',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text('House Owner'),
                      selected: _selectedAccountType == AccountType.houseOwner,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedAccountType = AccountType.houseOwner;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: Text('Cleaner'),
                      selected: _selectedAccountType == AccountType.cleaner,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedAccountType = AccountType.cleaner;
                        });
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Email TextField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
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
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                
                const SizedBox(height: 16),
                
                // Confirm Password TextField
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                
                const SizedBox(height: 24),
                
                // Register Button
                ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Register'),
                ),
                
                const SizedBox(height: 20),
                
                // Login Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? '),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Divider with OR text
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Google Sign-In Button
                OutlinedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Image.asset(
                    'assets/google_logo.png', 
                    height: 24,
                    width: 24,
                  ),
                  label: Text('Sign in with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Validation Methods (Placeholder implementations)
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

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Registration Handler (Placeholder)
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // Implement registration logic
      print('Registration attempted');
      print('Account Type: ${_selectedAccountType.name}');
    }
  }

  // Google Sign-In Handler (Placeholder)
  void _handleGoogleSignIn() {
    // Implement Google sign-in logic
    print('Google Sign-In attempted');
  }

  // Navigation to Login View (Placeholder)
  void _navigateToLogin() {
    // Implement navigation to login page
    // For example:
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView())
    );
    print('Navigating to Login View');
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}