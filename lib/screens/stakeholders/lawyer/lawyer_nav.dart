// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:law_help/screens/stakeholders/lawyer/home/show_cases.dart';
import 'package:law_help/screens/stakeholders/lawyer/lawyer_chat.dart';
import 'package:law_help/screens/stakeholders/lawyer/lawyer_doc.dart';
import 'package:law_help/screens/stakeholders/lawyer/home/lawyer_home.dart';
import 'package:law_help/screens/stakeholders/lawyer/news_screen.dart';

class ScreenModel {
  final Widget screen;
  final IconData icon;
  final String text;

  ScreenModel({
    required this.screen,
    required this.icon,
    required this.text,
  });
}

class LawyerScreen extends StatefulWidget {
  const LawyerScreen({super.key});

  @override
  _LawyerScreenState createState() => _LawyerScreenState();
}

class _LawyerScreenState extends State<LawyerScreen> {
  int _selectedIndex = 0;

  static final List<ScreenModel> screens = [
    ScreenModel(screen: AbsentStudentsScreen(), icon: Icons.home, text: "Home"),
    ScreenModel(
        screen: const LocatioDisplayScreen(), icon: Icons.chat, text: "Chat"),
    ScreenModel(screen: ComplaintsList(), icon: Icons.read_more, text: "News"),
    ScreenModel(
        screen: LocationTrackingScreen(), icon: Icons.add, text: "Documents"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[_selectedIndex].screen,
        extendBody: true,
        bottomNavigationBar: DotNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.black,
            items: [
              DotNavigationBarItem(
                icon: const Icon(Icons.home),
                selectedColor: Colors.yellow,
              ),
              DotNavigationBarItem(
                icon: const Icon(Icons.chat),
                selectedColor: Colors.yellow,
              ),
              DotNavigationBarItem(
                icon: const Icon(Icons.read_more),
                selectedColor: Colors.yellow,
              ),
              DotNavigationBarItem(
                icon: const Icon(Icons.add),
                selectedColor: Colors.yellow,
              ),
            ],
            selectedItemColor: Colors.yellow,
            unselectedItemColor: Colors.white));
  }
}
