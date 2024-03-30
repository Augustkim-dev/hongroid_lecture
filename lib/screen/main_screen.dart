import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/screen/favorite_screen.dart';
import 'package:flutter_store_pick_app/screen/home_screen.dart';
import 'package:flutter_store_pick_app/screen/my_info_screen.dart';

/// 메인 화면
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 화면 선택 위치
  List<Widget> _screenType = [
    HomeScreen(), // 홈 화면
    FavoriteScreen(), // 찜하기 화면
    MyInfoScreen(), // 내 정보 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenType.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xff14FF00),
        unselectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
