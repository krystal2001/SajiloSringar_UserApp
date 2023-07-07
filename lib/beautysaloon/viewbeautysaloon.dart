import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shringar1_app/beautysaloon/viewdetailbeautysaloon.dart';

class ViewAllBeautySaloonScreen extends StatefulWidget {
  const ViewAllBeautySaloonScreen({Key? key}) : super(key: key);

  @override
  _ViewSaloonScreenState createState() => _ViewSaloonScreenState();
}

class _ViewSaloonScreenState extends State<ViewAllBeautySaloonScreen> {
  void navigateToManageScreen(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final spaceData = documentSnapshot.data();
    if (spaceData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewDetailSpaceScreen(spaceData: spaceData),
        ),
      );
    }
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
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('beauticians')
                      .where('status', isEqualTo: 'yes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: querySnapshot.size,
                            itemBuilder: (context, index) {
                              DocumentSnapshot<Map<String, dynamic>>
                                  documentSnapshot = querySnapshot.docs[index];
                              Map<String, dynamic>? spaceData =
                                  documentSnapshot.data();
                              if (spaceData != null) {
                                return ListTile(
                                  title: Text(spaceData['shopname']),
                                  subtitle: Text(spaceData['location']),
                                  onTap: () => navigateToManageScreen(
                                    context,
                                    documentSnapshot,
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                    return const Text('No beauty salons found');
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
