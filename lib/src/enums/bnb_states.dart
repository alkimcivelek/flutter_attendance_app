import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MenuState { dashboard, attendance, account}

class TabItemData {
  final String label;
  final IconData? icon;
  final IconData? faIcon;

  TabItemData({required this.label, required this.icon, required this.faIcon});

  static Map<MenuState, TabItemData> allTabs = {
    MenuState.dashboard:
        TabItemData(label: "Anasayfa", icon: Icons.home, faIcon: null),
    MenuState.attendance:
        TabItemData(label: "Yoklama", icon: null, faIcon: FontAwesomeIcons.pen),
    MenuState.account:
        TabItemData(label: "Hesap", icon: Icons.person, faIcon: null),
  };
}
