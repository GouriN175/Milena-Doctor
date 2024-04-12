import 'package:docside_1/login.dart';
import 'package:docside_1/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  String? gender; //front
  String? yearsOfExperience; //front

  final FirebaseAuthService _auth = FirebaseAuthService();
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController(); 
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _yearOfRegistrationController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  List<String> genders = ['Male', 'Female'];
  List<String> experienceRanges = ['1-3', '3-6', '6-9', '9-12', '12-15', '15+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'SignUp',
          style: TextStyle(color: Colors.white),
        ),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Full Name",
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _ageController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Age",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Gender",
                  prefixIcon: SizedBox(width: 155),
                ),
                items: genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Center(
                      child: Text(
                        gender,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _registrationNumberController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Registration No.",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextField(
                controller: _yearOfRegistrationController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Year of Registration",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: yearsOfExperience,
                onChanged: (String? newValue) {
                  setState(() {
                    yearsOfExperience = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Experience",
                  prefixIcon: SizedBox(width: 160),
                ),
                items: experienceRanges.map((String yearsOfExperience) {
                  return DropdownMenuItem<String>(
                    value: yearsOfExperience,
                    child: Center(
                      child: Text(
                        yearsOfExperience,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _specializationController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Specialisation",
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _contactNumberController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Contact Number",
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 15),
              TextField(
                controller: _emailController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Email",
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Password",
                ),
                obscureText: true, // Hide text
              ),
              SizedBox(height: 15),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Confirm Password",
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 100,
                height: 50,
                child: TextButton(
                    onPressed: _signUp,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue),
                    child: const Text('Sign Up')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'age': _ageController.text,
        'gender': gender,
        'registrationNumber': _registrationNumberController.text,
        'yearOfRegistration': _yearOfRegistrationController.text,
        'yearsOfExperience': yearsOfExperience,
        'specialization': _specializationController.text,
        'contactNumber': _contactNumberController.text,
        'email': email,
      };

      try {
        await _firestore.collection('Dr.signup').doc(user.uid).set(userData);
        print("User details stored in Firestore");
      } catch (e) {
        print("Error storing user details: $e");
      }
      print("User Created");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      print("Error in user creation");
    }
  }
}
