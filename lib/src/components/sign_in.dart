import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yoklama_sistemi/src/helpers/constants.dart';
import 'package:yoklama_sistemi/src/helpers/functions.dart';
import 'package:yoklama_sistemi/src/pages/home.dart';
import 'package:yoklama_sistemi/src/services/database.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, required this.toggleView}) : super(key: key);
  final String title = 'Registration';
  final Function toggleView;
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  QuerySnapshot? sugSnapshot;

  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //validating
  final TextEditingController _emailController =
      TextEditingController(); //değişiklikleri dinleme
  final TextEditingController _passwordController = TextEditingController();
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
                  height: 30,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Giriş Yap",
                    style: GoogleFonts.lora(
                        textStyle: TextStyle(
                            color: Color.fromARGB(233, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 28)),
                  )
                ]),
                SizedBox(
                  height: 30,
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
                                  size: 14,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            activeColor: Colors.black45,
                            value: isChecked,
                            onChanged: (bool? value) => setState(() {
                                  isChecked = value!;
                                })),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            "Beni Hatırla",
                            style: GoogleFonts.lora(
                                textStyle: TextStyle(
                                    color: Color.fromARGB(221, 255, 255, 255),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            "Şifrenizi mi unuttunuz?",
                            style: GoogleFonts.lora(
                                textStyle: TextStyle(
                                    color: Color.fromARGB(221, 255, 255, 255),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () async {
                      await _login();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white60),
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Giriş Yap",
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
                        "Henüz bir hesabınız yok mu? ",
                        style: GoogleFonts.lora(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                      Text(
                        "Kayıt Olun.",
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
                Container(
                  alignment: Alignment.center,
                  child: Text(
                      _success == null
                          ? ''
                          : (_success!
                              ? 'Successfully login ' + _userEmail!
                              : 'Login failed'),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _login() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (FirebaseAuth.instance.currentUser == null) {
          debugPrint("Giriş yapmış kullanıcı yok. Giriş yapılıyor...");
        } else {
          debugPrint("Kullanıcı giriş yapmış. Tekrar giriş yapılamaz. Hata!");
        }
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if (userCredential != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(_emailController.text);

          await HelperFunctions.setUserLoggedIn(true);
          
          await HelperFunctions.setUserFullName(
              userInfoSnapshot.docs[0].get("name"),
              userInfoSnapshot.docs[0].get("surname"));
      

          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => HomePage()));

          debugPrint("Giriş başarılı. Giriş yapan kullanıcı " +
              userCredential.user!.email.toString());
          await HelperFunctions.setUserLoggedIn(true);
          setState(() {
            isChecked = true;
            _userEmail = userCredential.user!.email;
          });
        }
      } else {
        debugPrint("Hatalı giriş! Kullanıcı bulunamadı.");
        setState(() {
          isChecked = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      debugPrint("Hata: " + e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
