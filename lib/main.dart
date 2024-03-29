import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/screen/login_screen.dart';
import 'package:flutter_store_pick_app/screen/register_screen.dart';
import 'package:flutter_store_pick_app/screen/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gocpskrrkaptukxazafb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvY3Bza3Jya2FwdHVreGF6YWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYyNDY4MDIsImV4cCI6MjAyMTgyMjgwMn0.Eh_livKHLJfoR90PbovE0s5JTE-pe9x7qchMY4YpS-8',
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
      },
    );
  }
}
