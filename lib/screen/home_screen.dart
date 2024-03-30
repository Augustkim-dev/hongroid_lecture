import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          indoorEnable: true, // 실내 맵 사용 가능여부
          locationButtonEnable: true, // 내 위치로 이동 버튼
          consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부
        ),
        onMapReady: (controller) {},
      ),
    );
  }
}
