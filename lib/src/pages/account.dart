import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yoklama_sistemi/src/helpers/functions.dart';
import 'package:yoklama_sistemi/src/pages/authenticate.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("141d26"),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 15),
                      child: Text(
                        "Hesap",
                        style: GoogleFonts.lora(
                            textStyle: TextStyle(
                                color: Color.fromARGB(233, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 0,
                thickness: 2,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAccountOptionRow(
                    context, "Toplam Devamsızlığı Görüntüle"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAccountOptionRow(context, "Şifre Değiştir"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAccountOptionRow(context, "Güvenlik ve Gizlilik"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAccountOptionRow(context, "İletişim"),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(HexColor("#84C9FB")),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 40)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  onPressed: () async {
                    await HelperFunctions.setUserLoggedIn(false);
                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (BuildContext context) {
                          return AuthPage();
                        },
                      ),
                      (_) => false,
                    );
                  },
                  child: Text("Çıkış Yap",
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2.2,
                          color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: GoogleFonts.lora(
                    textStyle: TextStyle(
                        color: Color.fromARGB(233, 255, 255, 255),
                        fontWeight: FontWeight.normal,
                        fontSize: 15))),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
