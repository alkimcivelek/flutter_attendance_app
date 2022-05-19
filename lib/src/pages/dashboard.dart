import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yoklama_sistemi/src/pages/studies.dart';
import 'package:yoklama_sistemi/src/services/database.dart';

class GridDashboard extends StatefulWidget {
  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  DatabaseMethods db = DatabaseMethods();
  final TextEditingController _controller = TextEditingController();
  String locationMessage = "";
  bool atSchool = false;
  bool isCodeTrue = false;
  String isValid = "";
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (position.latitude >= 41.5059 && position.latitude < 41.5096) {
      if (position.longitude >= 36.1116 && position.longitude < 36.1160) {
        atSchool = true;
      } else {
        atSchool = false;
      }
    } else {
      atSchool = false;
    }
    var add = await GetAddressFromLatLong(position);
    if (!mounted) return;
    setState(() {
      locationMessage = add;
    });
  }

  Future<String> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    var address =
        '${atSchool ? "Samsun Üniversitesi Ballıca Kampüsü" : ""} ${placemarks.first.administrativeArea}, ${placemarks.first.street}/${placemarks.first.country}';
    return address;
  }

  @override
  Widget build(BuildContext context) {
    var color = 0xff453658;
    return Container(
      child: Scaffold(
        backgroundColor: HexColor("141d26"),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 15),
                    child: Text(
                      "Ana Sayfa",
                      style: GoogleFonts.lora(
                          textStyle: TextStyle(
                              color: Color.fromARGB(233, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white.withOpacity(0.05),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Image.asset(
                              "lib/images/map-marker.png",
                              color: Colors.red[300],
                              width: 19,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Text(
                            locationMessage.isEmpty
                                ? "Henüz tespit edilemedi."
                                : locationMessage,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection("cards").get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14.0,
                                    mainAxisSpacing: 14.0,
                                    childAspectRatio: 1.2),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data!.docs[index]
                                            .get("image") ==
                                        "lib/images/map.png") {
                                      LocationPermission permission;
                                      permission =
                                          await Geolocator.checkPermission();
                                      if (permission ==
                                          LocationPermission.denied) {
                                        permission = await Geolocator
                                            .requestPermission();
                                        if (permission ==
                                            LocationPermission.deniedForever) {
                                          return print(
                                              'Location Not Available');
                                        }
                                      }
                                      getCurrentLocation();
                                    } else if (snapshot.data!.docs[index]
                                            .get("image") ==
                                        "lib/images/book.png") {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  StudiesPage()));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: atSchool
                                            ? Colors.white.withOpacity(0.02)
                                            : atSchool == false &&
                                                    snapshot.data!.docs[index]
                                                            .get("image") !=
                                                        "lib/images/map.png"
                                                ? Colors.white.withOpacity(0.02)
                                                : Colors.white
                                                    .withOpacity(0.02),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.center,
                                      children: <Widget>[
                                        if (snapshot.data!.docs[index]
                                                .get("image") ==
                                            "lib/images/absenteeism.png") ...[
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                        Positioned(
                                          left: 5,
                                          right: 5,
                                          child: Image.asset(
                                            snapshot.data!.docs[index]
                                                .get("image"),
                                            width: 55,
                                            height: 55,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Positioned(
                                          top: 53,
                                          left: 5,
                                          right: 5,
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                .get("name"),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lora(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Positioned(
                                          top: 75,
                                          left: 5,
                                          right: 5,
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                .get("subtitle"),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lora(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (snapshot.data!.docs[index]
                                                .get("image") ==
                                            "lib/images/chat.png") ...[
                                          Positioned(
                                            top: 120,
                                            left: 5,
                                            child: Container(
                                              height: 30,
                                              width: 105,
                                              child: TextField(
                                                  controller: _controller,
                                                  cursorColor: Colors.white,
                                                  autofocus: false,
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                      fillColor: Colors.white
                                                          .withOpacity(0.12),
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10,
                                                              top: 8,
                                                              bottom: 8))),
                                            ),
                                          ),
                                          Positioned(
                                              right: 5,
                                              top: 110,
                                              child: TextButton(
                                                onPressed: () async {
                                                  var ss =
                                                      await db.getClassTime();

                                                  if (ss.docs.length > 0 &&
                                                      ss.docs[0].get("time") >
                                                          0) {
                                                    var code = await ss.docs[0]
                                                        .get("code");
                                                    if (_controller.text ==
                                                        code) {
                                                      MessageDialog
                                                          messageDialog =
                                                          MessageDialog(
                                                        dialogBackgroundColor:
                                                            HexColor("141d26"),
                                                        buttonOkColor:
                                                            HexColor("#4E944F"),
                                                        title: 'Başarılı',
                                                        titleColor:
                                                            Colors.white,
                                                        message:
                                                            'Kod doğrulandı. Yoklamanızı yapabilirsiniz.',
                                                        messageColor:
                                                            Colors.white,
                                                        buttonOkText: 'TAMAM',
                                                        dialogRadius: 15.0,
                                                        buttonRadius: 18.0,
                                                      );
                                                      messageDialog.show(
                                                          context,
                                                          barrierColor:
                                                              Colors.black,
                                                          barrierDismissible:
                                                              false);
                                                    } else {
                                                      MessageDialog
                                                          messageDialog =
                                                          MessageDialog(
                                                        dialogBackgroundColor:
                                                            HexColor("141d26"),
                                                        buttonOkColor:
                                                            HexColor("#B33030"),
                                                        title: 'Başarısız',
                                                        titleColor:
                                                            Colors.white,
                                                        message:
                                                            'Girilen kod hatalı.',
                                                        messageColor:
                                                            Colors.white,
                                                        buttonOkText: 'TAMAM',
                                                        dialogRadius: 15.0,
                                                        buttonRadius: 18.0,
                                                      );
                                                      messageDialog.show(
                                                          context,
                                                          barrierColor:
                                                              Colors.black,
                                                          barrierDismissible:
                                                              false);
                                                    }
                                                  } else {
                                                    MessageDialog
                                                        messageDialog =
                                                        MessageDialog(
                                                      dialogBackgroundColor:
                                                          HexColor("141d26"),
                                                      buttonOkColor:
                                                          HexColor("#B33030"),
                                                      title: 'Başarısız',
                                                      titleColor: Colors.white,
                                                      message:
                                                          'Oluşturulan kod geçerliliğini yitirdi.',
                                                      messageColor:
                                                          Colors.white,
                                                      buttonOkText: 'TAMAM',
                                                      dialogRadius: 15.0,
                                                      buttonRadius: 18.0,
                                                    );
                                                    messageDialog.show(context,
                                                        barrierColor:
                                                            Colors.black,
                                                        barrierDismissible:
                                                            false);
                                                  }
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                    backgroundColor:
                                                        HexColor("#84C9FB"),
                                                    onSurface: Colors.grey,
                                                    fixedSize: Size(8, 8)),
                                              ))
                                        ],
                                        atSchool &&
                                                snapshot.data!.docs[index]
                                                        .get("image") ==
                                                    "lib/images/map.png"
                                            ? Positioned(
                                                top: 120,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.22,
                                                child: FaIcon(
                                                  FontAwesomeIcons.check,
                                                  color: Colors.green[400],
                                                ),
                                              )
                                            : atSchool == false &&
                                                    snapshot.data!.docs[index]
                                                            .get("image") ==
                                                        "lib/images/map.png"
                                                ? Positioned(
                                                    top: 120,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.22,
                                                    child: FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                      color: Colors.red[400],
                                                    ),
                                                  )
                                                : Text("")
                                      ],
                                    ),
                                  ));
                            });
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Scaffold(
                          backgroundColor: HexColor("141d26"),
                          body: Center(
                              child: JumpingDotsProgressIndicator(
                            color: Colors.white,
                            fontSize: 80,
                          )),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
