import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:docside_1/patientProfile.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  _StackedNotificationsState createState() => _StackedNotificationsState();
}

class _StackedNotificationsState extends State<Alert> {
  List<String> notifications = [];

  String? name;
  @override
  void initState() {
    super.initState();
    fetchpatientDetails(); // Call fetchpatientDetails() method when the widget is initialized
  }

  void addNotification(String username, String message) {
    setState(() {
      notifications.add('$message');
    });
  }

  void removeNotification() {
    setState(() {
      if (notifications.isNotEmpty) {
        notifications.removeAt(0);
      }
    });
  }

  void goToPatientProfile() {
    // Navigate to the patient profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(
          Icons.message_outlined,
          color: Colors.white,
        ),
        title: const Text(
          'ALERTS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 20,
      ),
      body: Stack(
        children: [
          // Main content of the page
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(15),
              ),
              onPressed: () {
                String username = '$name'; // Replace with actual username
                addNotification(username, "New notification!");
              },
              child:
                  const Text('Refresh', style: TextStyle(color: Colors.white)),
            ),
          ),
          // Stacked notifications
          Positioned(
            top: 50.0,
            right: 10.0,
            left: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: notifications.map((message) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: GestureDetector(
                    onTap:
                        goToPatientProfile, // Navigate to patient profile page
                    child: Card(
                      elevation: 3.0,
                      child: ListTile(
                        tileColor: Colors.blue[100],
                        leading: const Icon(Icons.person),
                        title: Text(message),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            removeNotification();
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchpatientDetails() async {
    try {
      String? emailId = FirebaseAuth.instance.currentUser?.email;
      if (emailId != null) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('Dr.signup')
                .where('email', isEqualTo: emailId)
                .get();
        String? id = querySnapshot.docs.first.id;

        CollectionReference collectionReference = FirebaseFirestore.instance
            .collection('Dr.signup')
            .doc(id)
            .collection('Alerts');

        QuerySnapshot<Map<String, dynamic>> alertQuerySnapshot =
            await collectionReference.where('viewed', isEqualTo: false).get()
                as QuerySnapshot<Map<String, dynamic>>;

        for (QueryDocumentSnapshot<Map<String, dynamic>> alertDocument
            in alertQuerySnapshot.docs) {
          String alertDocumentId = alertDocument.id;

          DocumentReference alertDocumentReference =
              collectionReference.doc(alertDocumentId);

          DocumentSnapshot<Map<String, dynamic>> alertDocumentSnapshot =
              await alertDocumentReference.get()
                  as DocumentSnapshot<Map<String, dynamic>>;

          if (alertDocumentSnapshot.exists) {
            Map<String, dynamic> alertData = alertDocumentSnapshot.data() ?? {};

            String? patientDocId = alertData['patientdocId'];

            if (patientDocId != null) {
              DocumentReference patientDocRef = FirebaseFirestore.instance
                  .collection('Signupdata')
                  .doc(patientDocId);

              DocumentSnapshot<Map<String, dynamic>> patientDocSnapshot =
                  await patientDocRef.get()
                      as DocumentSnapshot<Map<String, dynamic>>;

              if (patientDocSnapshot.exists) {
                Map<String, dynamic> patientData =
                    patientDocSnapshot.data() ?? {};
                setState(() {
                  name = patientData['Name'];
                  // You can fetch other fields here
                });
                print('Name: $name');
              } else {
                print('Patient document not found');
              }
            } else {
              print('patientdocId not found in the alert document');
            }
          } else {
            print('Alert document not found');
          }
        }
      } else {
        print('Empty email');
      }
    } catch (e) {
      print('Error fetching patient details: $e');
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: Alert(),
  ));
}
