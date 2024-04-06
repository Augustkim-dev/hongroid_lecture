import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/model/food_store.dart';
import 'package:flutter_store_pick_app/screen/detail_screen.dart';
import 'package:flutter_store_pick_app/screen/edit_screen.dart';
import 'package:flutter_store_pick_app/screen/login_screen.dart';
import 'package:flutter_store_pick_app/screen/main_screen.dart';
import 'package:flutter_store_pick_app/screen/register_screen.dart';
import 'package:flutter_store_pick_app/screen/search_address_screen.dart';
import 'package:flutter_store_pick_app/screen/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gocpskrrkaptukxazafb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvY3Bza3Jya2FwdHVreGF6YWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYyNDY4MDIsImV4cCI6MjAyMTgyMjgwMn0.Eh_livKHLJfoR90PbovE0s5JTE-pe9x7qchMY4YpS-8',
  );

  await NaverMapSdk.instance.initialize(
    clientId: 'ttl8us9u92',
    onAuthFailed: (ex) => print('인증 실패 : $ex'),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        //   useMaterial3: true,
        // ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/main': (context) => MainScreen(),
          '/edit': (context) => EditScreen(),
          '/search_address': (context) => SearchAddressScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            // 상세 화면
            FoodStoreModel foodStoreModel =
                settings.arguments as FoodStoreModel;
            return MaterialPageRoute(
              builder: (context) {
                return DetailScreen(foodStoreModel: foodStoreModel);
              },
            );
          }
        });
  }
}
