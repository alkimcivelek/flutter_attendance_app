import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yoklama_sistemi/src/components/custom_bnb.dart';
import 'package:yoklama_sistemi/src/enums/bnb_states.dart';
import 'package:yoklama_sistemi/src/helpers/constants.dart';
import 'package:yoklama_sistemi/src/pages/account.dart';
import 'package:yoklama_sistemi/src/pages/account_admin.dart';
import 'package:yoklama_sistemi/src/pages/attendance.dart';
import 'package:yoklama_sistemi/src/pages/attendance_admin.dart';
import 'package:yoklama_sistemi/src/pages/dashboard.dart';
import 'package:yoklama_sistemi/src/pages/dashboard_admin.dart';
import 'package:yoklama_sistemi/src/services/database.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuState currentState = MenuState.dashboard;
  QuerySnapshot? sugSnapshot;

  Map<MenuState, Widget> allPages() {
    return {
      MenuState.dashboard: GridDashboard(),
      MenuState.attendance: TakeAttendance(),
      MenuState.account: const AccountPage()
    };
  }

  Map<MenuState, Widget> allPagesAdmin() {
    return {
      MenuState.dashboard: GridDashboardAdmin(),
      MenuState.attendance: TakeAttendanceAdmin(),
      MenuState.account: AccountPageAdmin()
    };
  }

  Map<MenuState, GlobalKey<NavigatorState>> navigatorKeys = {
    MenuState.dashboard: GlobalKey<NavigatorState>(),
    MenuState.attendance: GlobalKey<NavigatorState>(),
    MenuState.account: GlobalKey<NavigatorState>()
  };

  // Future<void> loadUserInfo() async {
  //   Constants.myFullName = await HelperFunctions.getUserFullName();
  // }

  @override
  Widget build(BuildContext context) {
    DatabaseMethods db = DatabaseMethods();
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentState]!.currentState!.maybePop(),
      child: FutureBuilder(
          future: db.getUserInfo(FirebaseAuth.instance.currentUser!.email!),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return CustomBottomNavbar(
                navigatorKeys: navigatorKeys,
                createPage: snapshot.data!.docs[0].get("role") == "student"
                    ? allPages()
                    : allPagesAdmin(),
                selectedMenu: currentState,
                onSelectedTab: (selectedTab) {
                  if (selectedTab == currentState) {
                    navigatorKeys[selectedTab]!
                        .currentState!
                        .popUntil((route) => route.isFirst);
                  } else {
                    setState(() {
                      currentState = selectedTab;
                    });
                  }
                  ;
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
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
            } else {
              return Container();
            }
          }),
    );
  }
}
