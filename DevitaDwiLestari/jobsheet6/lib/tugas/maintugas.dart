import 'package:flutter/material.dart';
import 'routes.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'gallery_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomePage(),
        Routes.profile: (context) => const ProfilePage(),
        Routes.gallery: (context) => const GalleryPage(),
      },
    );
  }
}
