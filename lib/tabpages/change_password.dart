import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shringar1_app/tabpages/profile_tab.dart';

import '../constants/colors.dart';
import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import '../constants/text_strings.dart';
import '../mainScreens/main_screen.dart';
import 'earning_tab.dart';
import 'home_tab.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  Future<void> updatePassword(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      try {
        // Verify the old password
        final currentUser = FirebaseAuth.instance.currentUser;
        final email = currentUser?.email;

        if (email != null) {
          // Sign in with the user's current email and old password
          final credential = EmailAuthProvider.credential(
            email: email,
            password: _oldPasswordController.text.trim(),
          );
          await currentUser?.reauthenticateWithCredential(credential);

          // Proceed with updating the password
          try {
            await currentUser
                ?.updatePassword(_newPasswordController.text.trim());

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
            Fluttertoast.showToast(
              msg: 'Updated Successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          } catch (e) {}
        }
      } on FirebaseAuthException catch (e) {
        print('Error: ${e.code} - ${e.message}');

        String errorMessage = 'An error occurred';

        switch (e.code) {
          case 'wrong-password':
            errorMessage = 'Invalid old password';
            break;
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Password Update Failed'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error: $e');
        // Handle other non-authentication related errors
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfileScreen(),
                ),
              );
            },
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: Text(
            tUpdatePassword,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage(tForgetPasswordImage)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _oldPasswordController,
                        decoration: const InputDecoration(
                          label: Text(tOldPassword),
                          prefixIcon: Icon(LineAwesomeIcons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          // Additional old password validation logic can be implemented here
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: const InputDecoration(
                          label: Text(tNewPassword),
                          prefixIcon: Icon(LineAwesomeIcons.fingerprint),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          // Additional new password validation logic can be implemented here
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: _confirmNewPasswordController,
                        decoration: const InputDecoration(
                          label: Text(tConfirmNewPassword),
                          prefixIcon: Icon(LineAwesomeIcons.fingerprint),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _newPasswordController.text.trim()) {
                            return 'Passwords do not match';
                          }
                          // Additional confirm new password validation logic can be implemented here
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => updatePassword(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            tUpdatePassword,
                            style: TextStyle(color: tDarkColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: tFormHeight),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
