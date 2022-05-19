import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yoklama_sistemi/src/services/database.dart';

class StudiesPage extends StatefulWidget {
  StudiesPage({Key? key}) : super(key: key);

  @override
  State<StudiesPage> createState() => _StudiesPageState();
}

class _StudiesPageState extends State<StudiesPage> {
  DatabaseMethods db = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: HexColor("141d26"),
          body: SafeArea(
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 15),
                    child: Text(
                      "Derslerim",
                      style: GoogleFonts.lora(
                          textStyle: TextStyle(
                              color: Color.fromARGB(233, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 28)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: FutureBuilder(
                      future: db.getAllStudies(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
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
                              startHour = startHour.length < 2
                                  ? "0" + startHour
                                  : startHour;
                              endHour =
                                  endHour.length < 2 ? "0" + endHour : endHour;
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                      foregroundColor: HexColor("#84C9FB"),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.15),
                                      child: Text(twoCharString)),
                                  title: Text(
                                    snapshot.data!.docs[index].get("name"),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                      startHour +
                                          ":" +
                                          startMinute +
                                          " - " +
                                          endHour +
                                          ":" +
                                          endMinute,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0)),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
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
              ),
            ]),
            // child: ListView.builder(
            //   itemBuilder: (BuildContext context, int index) {
            //     return Card(
            //       child: ListTile(
            //         title: Text("This is title"),
            //         subtitle: Text("This is subtitle"),
            //       ),
            //     );
            //   },
            //   itemCount: 4,
            //   shrinkWrap: true,
            //   padding: EdgeInsets.all(5),
            //   scrollDirection: Axis.vertical,
            // ),
          )),
    );
  }
}
