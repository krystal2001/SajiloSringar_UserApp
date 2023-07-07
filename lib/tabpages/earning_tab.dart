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

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningTabPageState createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningsTabPage> {
  final _formKey = GlobalKey<FormState>();
  final _shopnameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController();

  final RegExp _onlyAlphabetsRegExp = RegExp(r'[a-zA-Z]+');

  void dispose() {
    // _emailController.removeListener(_validateEmailOnChange);

    _shopnameController.dispose();
    _descriptionController.dispose();
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
                        _shopnameController.text = userData['shopname'];
                        _locationController.text = userData['location'];
                        _descriptionController.text = userData['description'];
                        _statusController.text = userData['status'];

                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _shopnameController,
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
                                controller: _locationController,
                                // initialValue: userData['email'],
                                decoration: InputDecoration(
                                  labelText: tEmail,
                                  prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                                ),

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                },
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: _descriptionController,

                                // initialValue: userData['phoneno'].toString(),
                                decoration: InputDecoration(
                                  labelText: tPhoneNo,
                                  prefixIcon: Icon(LineAwesomeIcons.phone),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }

                                  return null; // Return null to indicate the input is valid
                                },
                              ),
                              TextFormField(
                                controller: _statusController,

                                // initialValue: userData['phoneno'].toString(),
                                decoration: InputDecoration(
                                  labelText: "Status",
                                  prefixIcon: Icon(LineAwesomeIcons.phone),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
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
                                          .collection('beauticians')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .update({
                                        'shopname': _shopnameController.text,
                                        'location': _locationController.text,
                                        'description':
                                            _descriptionController.text,
                                        'status': _statusController.text,
                                      }).then((_) {
                                        // Successfully updated user data
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen(),
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
