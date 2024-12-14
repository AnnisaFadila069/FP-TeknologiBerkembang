import 'forgotpasswordpage.dart';
import 'registerpage.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Login Failed', 'Please fill out all fields!');
      return;
    }

    // Email format validation
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      _showErrorDialog(context, 'Login Failed', 'Invalid email format!');
      return;
    }

    try {
  final user = await _auth.loginUserWithEmailAndPassword(email, password);

  if (user != null) {
    // Navigate to the main screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  } else {
    _showErrorDialog(
      context,
      'Login Failed',
      'Invalid credentials. Please check your email and password.',
    );
  }
} catch (e) {
  String errorMessage;

  // Customize error messages based on the error type
  if (e.toString().contains('user-not-found')) {
    errorMessage = 'No account found for this email. Please sign up first.';
  } else if (e.toString().contains('wrong-password')) {
    errorMessage = 'Invalid email format. Please check and try again.';
  } else if (e.toString().contains('invalid-email')) {
    errorMessage = 'Invalid email format. Please check and try again.';
  } else {
    errorMessage = 'Invalid credentials. Please check your email and password.';
  }

  _showErrorDialog(context, 'Login Failed', errorMessage);
}

  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'Image/logo_bookmate.png',
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.book, size: 100, color: Colors.grey);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'BookMate',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: const Color(0xFFE4DECF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.brown),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscureText, // Untuk menyembunyikan teks
                          cursorColor: Colors.brown, // Ganti warna kursor jika perlu
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: const Color(0xFFE4DECF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.brown),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black, // Ganti warna ikon sesuai kebutuhan
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE4DECF),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child:
                              const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFFB3907A),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child:
                Row(mainAxisAlignment:
                    MainAxisAlignment.center,
                  children:[
                    const Text("Don't have an Account? ", style:
                        TextStyle(color:
                        Colors.white)),
                    TextButton(onPressed:
                        () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) =>
                                  const RegisterPage()));
                    },
                      child:
                      const Text('Register Here',
                        style:
                        TextStyle(color:
                        Colors.white,
                          decoration:
                          TextDecoration.underline)),
                    )
                  ],
                )
          )
        ],
      ),
    );
  }
}
