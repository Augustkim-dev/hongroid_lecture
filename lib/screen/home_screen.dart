import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NaverMapController _mapController;
  Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          indoorEnable: true, // 실내 맵 사용 가능여부
          locationButtonEnable: true, // 내 위치로 이동 버튼
          consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부
        ),
        onMapReady: (controller) async {
          _mapController = controller;
          // 이동 하고싶은 카메라 위치 추출 (내 위치)
          NCameraPosition myPosition = await getMyLocation();

          // 서버에 등록된 음식점 리스트 정보들을 위경도를 가지고와서 마커 (marker) 찍기
          // _buildMarkers();

          // 추출한 위치를 카메라 update (이동)
          _mapController
              .updateCamera(NCameraUpdate.fromCameraPosition(myPosition));
          mapControllerCompleter.complete(_mapController); // 지도 컨트롤러 완료 신호 전송
        },
      ),
    );
  }

  Future<NCameraPosition> getMyLocation() async {
    // 위치 권한을 체크해서 권한 허용이 되어있다면 내 현위치 정보 가져오기
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스를 이용할 수 있는지 체크 !
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // 위치 권한 현재 상태 체크
    permission = await Geolocator.checkPermission();

    // 만약 위치 권한 허용 팝업을 사용자가 거부했다면
    if (permission == LocationPermission.denied) {
      // 위치 권한 팝업 표시
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied forever');
    }

    // 현재 디바이스 기준 GPS 센서 값을 활용해서 현재 위치 추출
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return NCameraPosition(
        target: NLatLng(position.latitude, position.longitude), zoom: 12);
  }
}
