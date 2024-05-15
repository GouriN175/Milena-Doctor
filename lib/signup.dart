import 'package:docside_1/login.dart';
import 'package:docside_1/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docside_1/showsnackbar.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? gender;
  String? yearsOfExperience;

  // Instance of FirebaseAuthService
  final FirebaseAuthService _auth = FirebaseAuthService();
  late FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _yearOfRegistrationController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _registrationNumberController.dispose();
    _yearOfRegistrationController.dispose();
    _specializationController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void signup(BuildContext context) async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        // Prepare user data to be stored in Firestore
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
          // Store user data in Firestore
          await _firestore.collection('Dr.signup').doc(user.uid).set(userData);
          print("User details stored in Firestore");
        } catch (e) {
          print("Error storing user details: $e");
        }

        print("User Created");

        // Show a snackbar to inform the user about successful signup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        });
      } else {
        print("Error in user creation");
      }
    } catch (error) {
      // Show a snackbar with the error message if signup fails
      showSnackbar(context, 'Signup failed: $error');
    }
  }
  //signup method

  List<String> genders = ['Male', 'Female'];
  List<String> experienceRanges = ['1-3', '3-6', '6-9', '9-12', '12-15', '15+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'SignUp',
          style: TextStyle(color: Colors.white),
        ),
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
                  prefixIcon: const SizedBox(width: 155),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
                  prefixIcon: const SizedBox(width: 160),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Confirm Password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 100,
                height: 50,
                child: TextButton(
                    onPressed: () => signup(context),
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
}
