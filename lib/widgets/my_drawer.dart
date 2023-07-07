import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shringar1_app/beautysaloon/viewbeautysaloon.dart';
import '../splashScreen/splash_screen.dart';
import '../tabpages/profile_tab.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer header
          Container(
            height: 165,
            color: Colors.grey,
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Data is still loading
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data?.exists == true) {
                  // User data is available
                  Map<String, dynamic>? userData = snapshot.data?.data();
                  if (userData != null) {
                    // Display the user data
                    return Column(
                      children: [
                        Text(
                          userData['username'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData['email'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }
                }
                // User data not found
                return Text('User data not found');
              },
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          // Drawer body
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => ViewAllBeautySaloonScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.black,
              ),
              title: Text(
                "View Saloon",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => UpdateProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text(
                "About",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // fAuth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
