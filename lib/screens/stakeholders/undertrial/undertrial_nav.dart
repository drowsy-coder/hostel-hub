// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:law_help/screens/stakeholders/undertrial/fir_analyser.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_chat.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_home.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut%20map/ut_map.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_support.dart';

import '../../../models/screen_model.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _selectedIndex = 0;

  static final List<ScreenModel> screens = [
    ScreenModel(screen: const UTHome(), icon: Icons.home, text: "Home"),
    ScreenModel(
        screen: const UTSupport(), icon: Icons.support_agent, text: "Request"),
    ScreenModel(screen: MenuScreen(), icon: Icons.food_bank, text: "Mess"),
    ScreenModel(screen: Face(), icon: Icons.report, text: "Report"),
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
              icon: const Icon(Icons.report),
              selectedColor: Colors.yellow,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.read_more),
              selectedColor: Colors.yellow,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.food_bank),
              selectedColor: Colors.yellow,
            ),
          ],
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.white),
    );
  }
}
