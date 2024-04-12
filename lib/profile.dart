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
  User? _user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final docSnapshot =
        await _firestore.collection('Dr.signup').doc(_user?.uid).get();
    setState(() {
      _userData = docSnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: Icon(Icons.account_circle_rounded),
         title: Text('PROFILE'),
         backgroundColor: Colors.blue,
        elevation: 15,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 70,
              // backgroundImage: NetworkImage(_user.photoURL ?? ''),
            ),

            const SizedBox(height: 20),
             itemProfile('Name', _userData['name'] ?? '', Icons.person),
            const SizedBox(height: 10),
            itemProfile('Email', _user?.email ?? '', CupertinoIcons.mail),
            const SizedBox(
              height: 10,
            ),
            itemProfile('Phone', _userData['contactNumber'] ??'', CupertinoIcons.phone),
            const SizedBox(
              height: 10,
            ),
            itemProfile(
                'Registration Number', _userData['registrationNumber'] ?? '', CupertinoIcons.number),
            const SizedBox(height: 10),
            itemProfile('Specialization', _userData['specialization'] ?? '', Icons.plus_one_rounded),
            // Add other profile details you want to display
            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile(userId: _user?.uid ?? '' ),),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(15),
                      elevation: 5, // Add elevation for shadow effect
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(15),
                      elevation: 5, // Add elevation for shadow effect
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
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
                offset: Offset(0, 5),
                color: Color.fromARGB(255, 125, 153, 223).withOpacity(.2),
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
