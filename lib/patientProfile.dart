import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientProfile extends StatefulWidget {
  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  String? name;
  int? age;
  String? gender;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchpatientDetails(); // Call fetchpatientDetails() method when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alert Details"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  itemProfile(title: name.toString(), icon: Icons.person),
                  SizedBox(
                    height: 20,
                  ),
                  itemProfile(
                      title: '$age', icon: Icons.calendar_month_outlined),
                  SizedBox(
                    height: 20,
                  ),
                  itemProfile(title: '$gender', icon: Icons.transgender),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: chatMessages(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Placeholder for loading indicator
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Placeholder for error handling
                        } else {
// Use the data once it's available
                          return snapshot.data as Widget;
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    style: const TextStyle(color: Colors.blue),
                    decoration: const InputDecoration(
                      hintText: "Send Reply",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.3),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessagetoPatient();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessagetoPatient() async {
    String? message = controller.text;
    String? emailId = FirebaseAuth.instance.currentUser?.email;
    String? id;
    print('here 163');
    if (emailId != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Dr.signup')
              .where('email', isEqualTo: emailId)
              .get();
      id = querySnapshot.docs.first.id;
    } else {
      id = '';
      print('Empty email');
    }
    print('$emailId');

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('Dr.signup')
        .doc(id)
        .collection('Alerts');
    QuerySnapshot querySnapshot = await collectionReference.get();
    String? alertdocumentid = querySnapshot.docs.first.id;

    DocumentReference documentReference =
        collectionReference.doc(alertdocumentid);

    await documentReference
        .update({'Reply_from_Doctor': message, 'viewed': true});

    setState(() {
      controller.clear();
    });
  }

  Future<void> fetchpatientDetails() async {
    String? emailId = FirebaseAuth.instance.currentUser?.email;
    String? id;
    print('here 163');
    if (emailId != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Dr.signup')
              .where('email', isEqualTo: emailId)
              .get();
      id = querySnapshot.docs.first.id;
    } else {
      id = '';
      print('Empty email');
    }
    print('$emailId');

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('Dr.signup')
        .doc(id)
        .collection('Alerts');
    QuerySnapshot querySnapshot = await collectionReference.get();
    String? alertdocumentid = querySnapshot.docs.first.id;

    DocumentReference documentReference =
        collectionReference.doc(alertdocumentid);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    String? patientdocId = data['patientdocId'];

    CollectionReference collectionReference1 =
        FirebaseFirestore.instance.collection('Signupdata');

    DocumentReference patientdocref = collectionReference1.doc(patientdocId);
    DocumentSnapshot snapshot = await patientdocref.get();
    Map<String, dynamic> patientdata = snapshot.data() as Map<String, dynamic>;
    setState(() {
      name = patientdata['Name'];

      age = patientdata['Age'];
      gender = patientdata['Gender'];
    });

    print('$name  $age $gender');
  }
}

Future<Widget> chatMessages() async {
  // Placeholder for database query to check if Alert Data exists
  bool alertData = false; // Placeholder for checking if alert data exists
  String? alert_nature;
  String? alert_message;
  String? alert_data;
  print("here 133");
  Map<String, dynamic>? data = await fetchAlertDetails();
  alert_nature = data['alert_nature'];
  alert_message = data['alert_message'];
  Timestamp dateTime = data['timestamp'];
  DateTime dt = dateTime.toDate();
  if (alert_nature == 'Not in DB') {
    alert_data = data['alert_data'];
    alertData = true;
  }
  print("here 141");
  return ListView(
    children: [
      MessageTile(
        message: 'Nature of Alert: ${alert_nature.toString()}',
        sender: " ",
        sentByMe: false,
      ),
      MessageTile(
        message: 'Alert Message :\n ${alert_message.toString()}',
        sender:
            "Time of Alert: ${dt.hour}:${dt.minute} (${dt.day}-${dt.month}-${dt.year})",
        sentByMe: false,
      ),
      if (alertData)
        MessageTile(
          message: 'Alert Data: ${alert_data.toString()}',
          sender: "System",
          sentByMe: false,
        ),
    ],
  );
}

Future<Map<String, dynamic>> fetchAlertDetails() async {
  String? emailId = FirebaseAuth.instance.currentUser?.email;
  String? id;
  print('here 194');
  if (emailId != null) {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Dr.signup')
        .where('email', isEqualTo: emailId)
        .get();
    id = querySnapshot.docs.first.id;
  } else {
    id = '';
    print('Empty email');
  }
  print('$emailId');
  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('Dr.signup')
      .doc(id)
      .collection('Alerts');
  QuerySnapshot querySnapshot = await collectionReference.get();
  String? alertdocumentid = querySnapshot.docs.first.id;

  DocumentReference documentReference =
      collectionReference.doc(alertdocumentid);
  DocumentSnapshot documentSnapshot = await documentReference.get();

  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  return data;
}

class itemProfile extends StatelessWidget {
  const itemProfile({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Color.fromARGB(255, 125, 153, 223).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(title),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: sentByMe ? Colors.blue : Colors.blue,
          borderRadius: sentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: sentByMe ? Colors.blue : Colors.white,
                fontSize: 17,
              ),
            ),
            if (!sentByMe)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  sender,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PatientProfile(),
  ));
}
