import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yoklama_sistemi/src/services/database.dart';

class TakeAttendance extends StatefulWidget {
  TakeAttendance({Key? key}) : super(key: key);

  @override
  State<TakeAttendance> createState() => TakeAttendanceState();
}

class TakeAttendanceState extends State<TakeAttendance> {
  final DatabaseMethods db = DatabaseMethods();
  final DateTime now = DateTime.now();
  bool isAttendanceVisible = false;
  bool isClicked = false;
  String? _timeHour;
  String? _timeMinute;
  String? dayOfTheWeek;
  void _getTime() {
    // final String formattedDateTime = _formatDateTime(now);
    if (!mounted) return;
    setState(() {
      _timeHour = DateTime.now().hour.toString();
      _timeMinute = DateTime.now().minute.toString();
      dayOfTheWeek = DateFormat.EEEE("tr").format(DateTime.now());
    });
  }

  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat('MM/dd/yyyy H:m:ss').format(dateTime);
  // }

  @override
  void initState() {
    initializeDateFormatting();
    _timeHour = DateTime.now().hour.toString();
    _timeMinute = DateTime.now().minute.toString();
    // _timeMinute = _formatDateTime(DateTime.now()).split(":")[1];
    dayOfTheWeek = DateFormat.EEEE("tr").format(now);
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("141d26"),
        body: SafeArea(
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 15),
                    child: Text(
                      "Yoklama İşlemleri",
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
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Container(
                child: Card(
                  color: Colors.white.withOpacity(0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                              "Yoklama işlemini gerçekleştirmek için gerekli doğrulamaları yapalısınız.",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                        CircleAvatar(
                            maxRadius: 13,
                            foregroundColor: HexColor("141d26"),
                            backgroundColor: HexColor("#FEC260"),
                            child: Icon(
                              FontAwesomeIcons.info,
                              size: 18,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Container(
                child: Card(
                  color: Colors.white.withOpacity(0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Konum doğrulandı",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            CircleAvatar(
                                maxRadius: 13,
                                foregroundColor: HexColor("141d26"),
                                backgroundColor: Colors.red[300],
                                child: Icon(
                                  FontAwesomeIcons.exclamation,
                                  size: 18,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ders yoklaması için kod doğrulandı",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            CircleAvatar(
                                maxRadius: 13,
                                foregroundColor: HexColor("141d26"),
                                backgroundColor: Colors.red[300],
                                child: Icon(
                                  FontAwesomeIcons.exclamation,
                                  size: 18,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: FutureBuilder(
                  future: db.getStudy(dayOfTheWeek!, int.parse(_timeHour!)),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            String twoCharString = snapshot.data!.docs[index]
                                .get("name")
                                .toString()
                                .split(" ")[0]
                                .characters
                                .first;
                            twoCharString += snapshot.data!.docs[index]
                                .get("name")
                                .toString()
                                .split(" ")[1]
                                .characters
                                .first;
                            String startHour = snapshot.data!.docs[index]
                                .get('startHour')
                                .toString();
                            String endHour = snapshot.data!.docs[index]
                                .get('endHour')
                                .toString();
                            String startMinute = snapshot.data!.docs[index]
                                .get('startMinute')
                                .toString();
                            String endMinute = snapshot.data!.docs[index]
                                .get('endMinute')
                                .toString();
                            if (int.parse(_timeHour!) >= int.parse(startHour) &&
                                int.parse(_timeHour!) <= int.parse(endHour)) {
                              if (int.parse(_timeHour!) == int.parse(endHour)) {
                                if (int.parse(_timeMinute!) <=
                                    int.parse(endMinute)) {
                                  startHour = startHour.length < 2
                                      ? "0" + startHour
                                      : startHour;
                                  endHour = endHour.length < 2
                                      ? "0" + endHour
                                      : endHour;
                                  startMinute = startMinute.length < 2
                                      ? "0" + startMinute
                                      : startMinute;
                                  endMinute = endMinute.length < 2
                                      ? "0" + endMinute
                                      : endMinute;

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color: Colors.white.withOpacity(0.08),

                                    child: Container(
                                        padding: EdgeInsets.only(
                                            left: 4,
                                            top: 8,
                                            bottom: 8,
                                            right: 4),
                                        // color: Color(0xFF015FFF),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (await db
                                                          .getClassNameOnSpecificDate(
                                                              db.getClassDate(),
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "name"))) {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isAttendanceVisible =
                                                              false;
                                                        });
                                                      } else if (isClicked ==
                                                          false) {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isClicked = true;
                                                          isAttendanceVisible =
                                                              true;
                                                        });
                                                      } else {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isClicked = false;
                                                          isAttendanceVisible =
                                                              false;
                                                        });
                                                      }
                                                    },
                                                    child: Row(children: [
                                                      Text(
                                                          "DERSLERİ LİSTELEMEK İÇİN TIKLA",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0)),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            HexColor("#84C9FB"),
                                                        size: 30,
                                                      ),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await db.takeAttendance(snapshot
                                                    .data!.docs[index]
                                                    .get("name"));

                                                MessageDialog messageDialog =
                                                    MessageDialog(
                                                        dialogBackgroundColor:
                                                            HexColor("141d26"),
                                                        buttonOkColor:
                                                            HexColor("#4E944F"),
                                                        title: 'İşlem Başarılı',
                                                        titleColor:
                                                            Colors.white,
                                                        message:
                                                            '${snapshot.data!.docs[index].get("name")} dersi için yoklama kaydınız başarı ile alınmıştır.',
                                                        messageColor:
                                                            Colors.white,
                                                        buttonOkText: 'TAMAM',
                                                        dialogRadius: 15.0,
                                                        buttonRadius: 18.0,
                                                        iconButtonOk:
                                                            Icon(Icons.one_k));
                                                messageDialog.show(context,
                                                    barrierColor: Colors.black,
                                                    barrierDismissible: false);
                                                if (await db
                                                    .getClassNameOnSpecificDate(
                                                        db.getClassDate(),
                                                        snapshot
                                                            .data!.docs[index]
                                                            .get("name"))) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isAttendanceVisible = false;
                                                  });
                                                } else {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isAttendanceVisible = true;
                                                  });
                                                }
                                              },
                                              child: Visibility(
                                                visible: isAttendanceVisible,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CircleAvatar(
                                                            foregroundColor:
                                                                HexColor(
                                                                    "#84C9FB"),
                                                            backgroundColor:
                                                                Colors.white
                                                                    .withOpacity(
                                                                        0.15),
                                                            child: Text(
                                                                twoCharString)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .get(
                                                                            "name"),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0)),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4.0),
                                                                  child: Text(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .get(
                                                                              "day"),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12.0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: Text(
                                                                startHour +
                                                                    ":" +
                                                                    startMinute +
                                                                    " - " +
                                                                    endHour +
                                                                    ":" +
                                                                    endMinute,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        13.0)),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.add,
                                                          color: HexColor(
                                                              "#84C9FB"),
                                                          size: 23,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // SizedBox(height: 35.0),
                                          ],
                                        )),
                                    // child: ListTile(
                                    //     title: Text(
                                    //       snapshot.data!.docs[index].get("name"),
                                    //       style: TextStyle(color: Colors.white),
                                    //     ),
                                    //     subtitle: Text(
                                    //       snapshot.data!.docs[index].get("day"),
                                    //       style: TextStyle(color: Colors.white),
                                    //     )),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                startHour = startHour.length < 2
                                    ? "0" + startHour
                                    : startHour;
                                endHour = endHour.length < 2
                                    ? "0" + endHour
                                    : endHour;
                                startMinute = startMinute.length < 2
                                    ? "0" + startMinute
                                    : startMinute;
                                endMinute = endMinute.length < 2
                                    ? "0" + endMinute
                                    : endMinute;

                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.white.withOpacity(0.08),

                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 4, top: 8, bottom: 8, right: 4),
                                      // color: Color(0xFF015FFF),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (await db
                                                        .getClassNameOnSpecificDate(
                                                            db.getClassDate(),
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get("name"))) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        isAttendanceVisible =
                                                            false;
                                                      });
                                                    } else if (isClicked ==
                                                        false) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        isClicked = true;
                                                        isAttendanceVisible =
                                                            true;
                                                      });
                                                    } else {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        isClicked = false;
                                                        isAttendanceVisible =
                                                            false;
                                                      });
                                                    }
                                                  },
                                                  child: Row(children: [
                                                    Text(
                                                        "DERSLERİ LİSTELEMEK İÇİN TIKLA",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15.0)),
                                                    Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          HexColor("#84C9FB"),
                                                      size: 30,
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await db.takeAttendance(snapshot
                                                  .data!.docs[index]
                                                  .get("name"));

                                              MessageDialog messageDialog =
                                                  MessageDialog(
                                                      dialogBackgroundColor:
                                                          HexColor("141d26"),
                                                      buttonOkColor:
                                                          HexColor("#4E944F"),
                                                      title: 'İşlem Başarılı',
                                                      titleColor: Colors.white,
                                                      message:
                                                          '${snapshot.data!.docs[index].get("name")} dersi için yoklama kaydınız başarı ile alınmıştır.',
                                                      messageColor:
                                                          Colors.white,
                                                      buttonOkText: 'TAMAM',
                                                      dialogRadius: 15.0,
                                                      buttonRadius: 18.0,
                                                      iconButtonOk:
                                                          Icon(Icons.one_k));
                                              messageDialog.show(context,
                                                  barrierColor: Colors.black,
                                                  barrierDismissible: false);
                                              if (await db
                                                  .getClassNameOnSpecificDate(
                                                      db.getClassDate(),
                                                      snapshot.data!.docs[index]
                                                          .get("name"))) {
                                                if (!mounted) return;
                                                setState(() {
                                                  isAttendanceVisible = false;
                                                });
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  isAttendanceVisible = true;
                                                });
                                              }
                                            },
                                            child: Visibility(
                                              visible: isAttendanceVisible,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CircleAvatar(
                                                          foregroundColor:
                                                              HexColor(
                                                                  "#84C9FB"),
                                                          backgroundColor:
                                                              Colors.white
                                                                  .withOpacity(
                                                                      0.15),
                                                          child: Text(
                                                              twoCharString)),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          "name"),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.0)),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                child: Text(
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .get(
                                                                            "day"),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0)),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          child: Text(
                                                              startHour +
                                                                  ":" +
                                                                  startMinute +
                                                                  " - " +
                                                                  endHour +
                                                                  ":" +
                                                                  endMinute,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      13.0)),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color:
                                                            HexColor("#84C9FB"),
                                                        size: 23,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // SizedBox(height: 35.0),
                                        ],
                                      )),
                                  // child: ListTile(
                                  //     title: Text(
                                  //       snapshot.data!.docs[index].get("name"),
                                  //       style: TextStyle(color: Colors.white),
                                  //     ),
                                  //     subtitle: Text(
                                  //       snapshot.data!.docs[index].get("day"),
                                  //       style: TextStyle(color: Colors.white),
                                  //     )),
                                );
                              }
                            } else {
                              return Container();
                            }
                          },
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(5),
                          scrollDirection: Axis.vertical,
                        ),
                      );
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
          ]),
        ));
  }
}
