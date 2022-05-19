import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yoklama_sistemi/src/helpers/constants.dart';
import 'package:yoklama_sistemi/src/helpers/functions.dart';
import 'package:yoklama_sistemi/src/pages/authenticate.dart';
import 'package:yoklama_sistemi/src/pages/home.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;

  Future getUserLoggeInState() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLoggeInState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
         
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!
                  .unfocus(disposition: UnfocusDisposition.scope);
            },
            child: MaterialApp(
              title: 'Flutter Chat App',
              home: userIsLoggedIn != null
                  ? userIsLoggedIn == true
                      ? HomePage()
                      : AuthPage()
                  : Container(
                      child: Center(child: AuthPage()),
                    ),
              debugShowCheckedModeBanner: false,
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: HexColor("141d26"),
                body: Center(
                    child: JumpingDotsProgressIndicator(
                  color: Colors.white,
                  fontSize: 80,
                )),
              ),
            ),
          ),
        );
      },
    );
  }
}
