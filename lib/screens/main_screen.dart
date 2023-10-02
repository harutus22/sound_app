import 'package:flutter/material.dart';
import 'package:sound_app/screens/sounds_screen.dart';
import 'package:sound_app/screens/profile_screen.dart';
import 'package:sound_app/screens/home_screen.dart';

import '../main.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late SoundsScreen soundsScreen;
  final screens = [const HomeScreen(), SoundsScreen(), const ProfileScreen()];

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    soundsScreen = screens[1] as SoundsScreen;
    // startAndroidMethod("get_ads");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xff16123D),
        body: SafeArea(
          child: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff181F55),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blueGrey,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          onTap: (index) => setState(() {
            currentIndex = index;
            if (index == 1) {
              soundsScreen.key.currentState!.setList();
            }
          }),
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/home.png"),
                ),
                label: 'Home',
                activeIcon: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff596BFC),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/home.png",
                      ),
                    ))),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/sounds.png"),
                ),
                label: 'Sounds',
                activeIcon: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff596BFC),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/sounds.png",
                      ),
                    ))),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/profile.png"),
                ),
                label: 'Profile',
                activeIcon: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff596BFC),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/images/profile.png",
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
