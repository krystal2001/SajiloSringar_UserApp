import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shringar1_app/tabpages/profile_tab.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class ViewDetailSpaceScreen extends StatefulWidget {
  final Map<String, dynamic> spaceData;

  const ViewDetailSpaceScreen({Key? key, required this.spaceData})
      : super(key: key);

  @override
  _ViewDetailSpaceScreenState createState() => _ViewDetailSpaceScreenState();
}

class _ViewDetailSpaceScreenState extends State<ViewDetailSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();
  final _shopnameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController();

  late String uid;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phonenoController.dispose();
    _shopnameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: const Text('Beauty Saloon'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('beauticians')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;
                      if (querySnapshot.size > 0) {
                        // Display the selected parking space data
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>>
                                documentSnapshot = querySnapshot.docs[index];
                            Map<String, dynamic>? spaceData =
                                documentSnapshot.data();
                            if (spaceData != null) {
                              // Check if the selected parking space matches the spaceData
                              if (spaceData['location'] ==
                                      widget.spaceData['location'] &&
                                  spaceData['shopname'] ==
                                      widget.spaceData['shopname']) {
                                uid = spaceData['uid'];
                                _locationController.text =
                                    spaceData['location'];
                                _shopnameController.text =
                                    spaceData['shopname'];
                                _descriptionController.text =
                                    spaceData['description'];

                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // FormHeaderWidget(
                                      //   image: tRentYourSpaceImage,
                                      //   subTitle: 'Parking Space Detail',
                                      // ),
                                      TextFormField(
                                        controller: _locationController,
                                        decoration: InputDecoration(
                                          labelText: tLocation,
                                          prefixIcon: Icon(Icons.location_city),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a location';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      TextFormField(
                                        controller: _shopnameController,
                                        decoration: InputDecoration(
                                          labelText: "Shop Name",
                                          prefixIcon: Icon(Icons.public_sharp),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a type';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      TextFormField(
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                          labelText: tRate,
                                          prefixIcon: Icon(
                                              Icons.currency_exchange_sharp),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a rate';
                                          }
                                          return null;
                                        },
                                      ),

                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc(documentSnapshot.id)
                                                  .update({
                                                'uid': uid,
                                                'location':
                                                    _locationController.text,
                                              }).then((_) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UpdateProfileScreen(),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }).catchError((error) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: Text(
                                                        'Failed to update user data: $error',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                            }
                                          },
                                          child: const Text('Book A Place'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      }
                    }
                    return const Text('User data not found');
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
