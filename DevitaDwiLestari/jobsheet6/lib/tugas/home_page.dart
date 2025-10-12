import 'package:flutter/material.dart';
import 'routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di Aplikasi Profil Mahasiswa',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.profile);
              },
              icon: const Icon(Icons.person),
              label: const Text('Lihat Profil Mahasiswa'),
            ),
          ],
        ),
      ),
    );
  }
}
