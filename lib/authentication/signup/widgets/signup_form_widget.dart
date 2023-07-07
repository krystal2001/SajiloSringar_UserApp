import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../login_screen.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();

  bool _isLoading = false;

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;

      Fluttertoast.showToast(
        msg: 'Signup successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      addUserDetails(
        uid,
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        int.parse(_phonenoController.text.trim()),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Error: ${e.code} - ${e.message}');

        String errorMessage = 'An error occurred';

        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'The email address is already in use by another account';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled';
            break;
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password';
            break;
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        print('Error: $e');
        // Handle other non-authentication related errors
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addUserDetails(String uid, String username, String email,
      String password, int phoneno) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference userRef = firestore.collection('users').doc(uid);

      await userRef.set({
        'uid': uid,
        'username': username,
        'email': email,
        'password': password,
        'phoneno': phoneno,
        'role': 'user',
      });
    } catch (e) {
      print('Error storing user details: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phonenoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your username';
                }

                if (value.trim() == value) {
                  return null; // No spaces found, valid username
                } else {
                  return 'Username cannot contain only spaces';
                }
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }

                final email = value.trim();
                final emailRegExp = RegExp(
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                );

                if (!emailRegExp.hasMatch(email)) {
                  return 'Please enter a valid email address';
                }

                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }

                return null;
              },
              obscureText: true,
            ),
            TextFormField(
              controller: _phonenoController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }

                if (value.length != 10) {
                  return 'Phone number must be exactly 10 digits';
                }

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
