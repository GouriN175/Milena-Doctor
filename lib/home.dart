import 'package:docside_1/alert.dart';
import 'package:docside_1/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int _currentSelectedIndex = 0;
  final _pages = [Alert(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
       backgroundColor: Colors.blue,
             items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_sharp),
                label: 'Alert',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
         
          currentIndex: _currentSelectedIndex,
          selectedItemColor: Colors.blue[100],
          iconSize: 40,
          onTap: (newIndex) {
            setState(() {
              _currentSelectedIndex = newIndex;
            });
          },
          elevation: 5),
    );
  }
}
