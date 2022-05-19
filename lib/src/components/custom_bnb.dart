import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yoklama_sistemi/src/enums/bnb_states.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar(
      {Key? key,
      required this.selectedMenu,
      required this.onSelectedTab,
      required this.createPage,
      required this.navigatorKeys})
      : super(key: key);
  final MenuState selectedMenu;
  final ValueChanged<MenuState> onSelectedTab;
  final Map<MenuState, Widget> createPage;
  final Map<MenuState, GlobalKey<NavigatorState>> navigatorKeys;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoTabScaffold(
        backgroundColor: HexColor("141d26"),
        tabBar: CupertinoTabBar(
          border: Border(top: BorderSide(color: Colors.transparent)),
          // border: Border(top: BorderSide.none),
          backgroundColor: HexColor("141d26"),
          activeColor: Colors.white,
          inactiveColor: Colors.white54,
          items: [
            _createBottomNavBar(MenuState.dashboard),
            _createBottomNavBar(MenuState.attendance),
            _createBottomNavBar(MenuState.account)
          ],
          onTap: (value) => onSelectedTab(MenuState.values[value]),
        ),
        tabBuilder: (context, index) {
          final itemToShow = MenuState.values[index];
          return CupertinoTabView(
            builder: (context) {
              return createPage[itemToShow] ??
                  Container(
                    child: Text("hata"),
                  );
            },
            navigatorKey: navigatorKeys[itemToShow],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _createBottomNavBar(MenuState tabItem) {
    final createdTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: createdTab!.icon == null
          ? Center(
              child: Container(
                child: Icon(
                  createdTab.faIcon,
                  size: 23,
                ),
              ),
            )
          : Center(
              child: Container(
                child: Icon(
                  createdTab.icon,
                  size: 29,
                ),
              ),
            ),
      label: createdTab.label,
    );
  }
}
