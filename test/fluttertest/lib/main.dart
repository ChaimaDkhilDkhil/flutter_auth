// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertest/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyForm(),
    );
  }
}

Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyForm extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MyForm({Key? key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Form'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (val) {
                if (val == null || val.isEmpty) return "Check email";
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Enter Email",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              controller: _passController,
              validator: (val) {
                if (val == null || val.isEmpty) return "Check password";
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Enter Password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passController.text,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      // ignore: avoid_print
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      // ignore: avoid_print
                      print('Wrong password provided for that user.');
                    }
                  }
                }
              },
              child: const Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Screen'),
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: const Text('Welcome!'),
      ),
    );
  }
}
