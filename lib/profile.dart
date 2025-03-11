// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:docside_1/editProfile.dart';
import 'package:docside_1/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot<Map<String, dynamic>> _userData ;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Future<void> _getUserData() async {
  //   final docSnapshot =
  //       await _firestore.collection('Dr.signup').doc(_user?.uid).get();
  //   setState(() {
  //     _userData = docSnapshot;
  //   });
  // }

  Future<void> _getUserData() async {
  try {
    final docSnapshot =
        await _firestore.collection('Dr.signup').doc(_user?.uid).get();
    if (docSnapshot.exists) {
      setState(() {
        _userData = docSnapshot;
      });
    } else {
      // Handle case where document doesn't exist for the user
      // You can set default values or show an error message
    }
  } catch (e) {
    // Handle error fetching data
    print('Error fetching user data: $e');
    // Optionally, show an error message to the user
  }
}


  @override
  Widget build(BuildContext context) {
        // Check if _userData is not initialized or still null
    if (!_userData.exists) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        title: const Text(
          'PROFILE',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 20,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  const PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 10),
                        Text("Edit Profile"),
                      ],
                    ),
                    value: "edit_profile",
                  ),
                  const PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text("Logout"),
                      ],
                    ),
                    value: "logout",
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value == "edit_profile") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditProfile(userId: _user?.uid ?? '')),
                  );
                } else if (value == "logout") {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 30),
          itemProfile('Name', _userData['name'] ?? '', Icons.person),
          SizedBox(height: 10),
          itemProfile('Email', _user?.email ?? '', CupertinoIcons.mail),
          SizedBox(height: 10),
          itemProfile('Phone', _userData['contactNumber'] ?? '',
              CupertinoIcons.phone),
          SizedBox(height: 10),
          itemProfile('Registration Number',
              _userData['registrationNumber'] ?? '', CupertinoIcons.number),
          SizedBox(height: 10),
          itemProfile('Specialization', _userData['specialization'] ?? '',
              Icons.plus_one_rounded),
          SizedBox(height: 20),
          // Add other profile details you want to display
        ],
      ),
    ),
  );
}

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: const Color.fromARGB(255, 125, 153, 223).withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  runApp(const MaterialApp(
    home: Profile(),
  ));
}
