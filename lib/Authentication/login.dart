import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0,horizontal:40.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0,horizontal:40.0),
            child:TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            ),
            SizedBox(height:20.0),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            SizedBox(height:15.0),
            GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          'Register?',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,          
          ),
        ),
      ),
    ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
  try {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      final String? username = FirebaseAuth.instance.currentUser?.displayName;
      final String? userid = FirebaseAuth.instance.currentUser?.uid;
      
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'username': username, 'userid': userid},
      );
    });
  } on FirebaseAuthException catch (e) {
    final errorMessage = e.message ?? 'An unknown error occurred';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
}