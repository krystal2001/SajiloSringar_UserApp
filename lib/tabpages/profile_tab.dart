import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../constants/colors.dart';
import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import '../constants/text_strings.dart';
import '../mainScreens/main_screen.dart';
import '../widgets/my_drawer.dart';
import 'change_password.dart';
import 'earning_tab.dart';
import 'home_tab.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();
  final RegExp _onlyAlphabetsRegExp = RegExp(r'[a-zA-Z]+');

  void dispose() {
    // _emailController.removeListener(_validateEmailOnChange);

    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
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
                  builder: (context) => MyDrawer(),
                ),
              );
            },
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: Text(
            tEditProfile,
            style: Theme.of(context).textTheme.headline4,
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
                          image: AssetImage(tProfileImage),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: tPrimaryColor,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.camera,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Data is still loading
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // User data is available
                      Map<String, dynamic>? userData = snapshot.data?.data();
                      if (userData != null) {
                        _usernameController.text = userData['username'];
                        _emailController.text = userData['email'];
                        _phonenoController.text =
                            userData['phoneno'].toString();
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: tFullName,
                                  prefixIcon: Icon(LineAwesomeIcons.user),
                                ),
                                // onChanged: (value) {
                                //   // Update the 'username' field value in the 'users' collection
                                //   FirebaseFirestore.instance
                                //       .collection('users')
                                //       .doc(FirebaseAuth
                                //           .instance.currentUser?.uid)
                                //       .update({'username': value});
                                // },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      _onlyAlphabetsRegExp),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your username';
                                  }

                                  if (value.trim() == value) {
                                    // No spaces found, valid username
                                    return null;
                                  } else {
                                    return 'Username cannot contain only spaces';
                                  }
                                },
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: _emailController,
                                // initialValue: userData['email'],
                                decoration: InputDecoration(
                                  labelText: tEmail,
                                  prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                                ),

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  final email = _emailController.text.trim();

                                  final emailRegExp = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                                  );
                                  if (!emailRegExp.hasMatch(email)) {
                                    return 'Please enter a valid email address';
                                  }
                                },
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: _phonenoController,

                                // initialValue: userData['phoneno'].toString(),
                                decoration: InputDecoration(
                                  labelText: tPhoneNo,
                                  prefixIcon: Icon(LineAwesomeIcons.phone),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                // onChanged: (value) {
                                //   // Update the 'phoneno' field value in the 'users' collection
                                //   FirebaseFirestore.instance
                                //       .collection('users')
                                //       .doc(FirebaseAuth
                                //           .instance.currentUser?.uid)
                                //       .update({'phoneno': value});
                                // },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }

                                  if (value.length < 10 || value.length > 10) {
                                    return 'Phone number must be exactly 10 digits';
                                  }
                                  return null; // Return null to indicate the input is valid
                                },
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      // Form is valid, update user data
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .update({
                                        'username': _usernameController.text,
                                        'email': _emailController.text,
                                        'phoneno': _phonenoController.text,
                                      }).then((_) {
                                        // Successfully updated user data
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyDrawer(),
                                          ),
                                        );
                                      }).catchError((error) {
                                        // Error occurred while updating user data
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(
                                                  'Failed to update user data: $error'),
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
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tPrimaryColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    tUpdateProfile,
                                    style: TextStyle(color: tDarkColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: tFormHeight),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePassword(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.green.shade500,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    tChangePassword,
                                    style: TextStyle(color: tDarkColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: tFormHeight),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: tJoined,
                                      style: const TextStyle(fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: tJoinedAt,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.1),
                                      elevation: 0,
                                      foregroundColor: Colors.red,
                                      shape: const StadiumBorder(),
                                      side: BorderSide.none,
                                    ),
                                    child: const Text(tDelete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    // User data not found
                    return Text('User data not found');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
