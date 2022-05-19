import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yoklama_sistemi/src/helpers/functions.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required this.toggleView}) : super(key: key);
  final String title = 'Registration';
  final Function toggleView;
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //validating
  final TextEditingController _emailController =
      TextEditingController(); //değişiklikleri dinleme
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  bool? _success;
  String? _userEmail;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("141d26"),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Sign Up",
                    style: GoogleFonts.lora(
                        textStyle: TextStyle(
                            color: Color.fromARGB(233, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 32)),
                  )
                ]),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(18)),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: _nameController,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 13),
                                      child: Icon(
                                        Icons.person,
                                        size: 19,
                                        color:
                                            Color.fromARGB(221, 255, 255, 255),
                                      ),
                                    ),
                                    labelStyle:
                                        TextStyle(color: Colors.white70),
                                    labelText: 'Adınız',
                                    contentPadding: const EdgeInsets.only(
                                        left: -4, top: 8, bottom: 8)),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(18)),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: _surnameController,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 13),
                                      child: Icon(
                                        Icons.person,
                                        size: 19,
                                        color:
                                            Color.fromARGB(221, 255, 255, 255),
                                      ),
                                    ),
                                    labelStyle:
                                        TextStyle(color: Colors.white70),
                                    labelText: 'Soyadınız',
                                    contentPadding: const EdgeInsets.only(
                                        left: -4, top: 8, bottom: 8)),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(18)),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _emailController,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Padding(
                                padding: EdgeInsets.only(left: 13),
                                child: Icon(
                                  Icons.mail,
                                  size: 19,
                                  color: Color.fromARGB(221, 255, 255, 255),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white70),
                              labelText: 'Öğrenci mail adresi',
                              contentPadding: const EdgeInsets.only(
                                  left: -4, top: 8, bottom: 8)),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 14, bottom: 0),
                    //   child: Text(
                    //     "Şifre",
                    //     style: GoogleFonts.lora(
                    //         textStyle: TextStyle(
                    //             color: Color.fromARGB(221, 255, 255, 255),
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 14)),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(18)),
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Padding(
                                padding: EdgeInsets.only(left: 13),
                                child: FaIcon(
                                  FontAwesomeIcons.lock,
                                  size: 16,
                                  color: Color.fromARGB(221, 255, 255, 255),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white70),
                              labelText: 'Şifre',
                              contentPadding: const EdgeInsets.only(
                                  left: -4, top: 8, bottom: 8)),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          color: Colors.transparent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Kayıt Ol",
                          style: GoogleFonts.lora(
                              textStyle: TextStyle(
                                  color: Color.fromARGB(247, 243, 243, 243),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "-VEYA-",
                      style: GoogleFonts.lora(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),

                SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () => {widget.toggleView()},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Zaten bir hesabınız mı var? ",
                        style: GoogleFonts.lora(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                      Text(
                        "Giriş Yapın.",
                        style: GoogleFonts.lora(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   child: Text(
                //       _success == null
                //           ? ''
                //           : (_success!
                //               ? 'Successfully registered ' + _userEmail!
                //               : 'Registration failed'),
                //       style: TextStyle(fontSize: 18, color: Colors.white),
                //       textAlign: TextAlign.center),
                // )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      if (userCredential != null) {
        await addUser();
        await HelperFunctions.setUserLoggedIn(true);
        await HelperFunctions.setUserEmail(_emailController.text);
        setState(() {
          _success = true;
          _userEmail = userCredential.user!.email;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': "student"
        })
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
