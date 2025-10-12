import 'package:flutter/material.dart';
import 'routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
      final List<String> matkulSemester5 = [
    "Perencanaan Sumber Daya",
    "Pemrograman Mobile",
    "Keselamatan dan Kesehatan Kerja",
    "Metodologi Penelitian",
    "Penjaminan Mutu Perangkat Lunak",
    "Manajemen Proyek Sistem Informasi",
    "Kecerdasan Bisnis",
    "Manajemen Rantai Pasok",
    "Audit Sistem Informasi",
  ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Mahasiswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: () {
              Navigator.pushNamed(context, Routes.gallery);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Devita Dwi Lestari",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text("NIM: 2341760002"),
                        Text("Program Studi: Sistem Informasi"),
                        Text("Politeknik Negeri Malang"),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Mahasiswa semester 5 yang aktif dalam kegiatan akademik dan organisasi kampus. Memiliki minat di bidang pengembangan aplikasi mobile dan analisis data.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Daftar Mata Kuliah Semester 5",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: matkulSemester5.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.book, color: Colors.teal),
                        title: Text(matkulSemester5[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.gallery);
                },
                icon: const Icon(Icons.image),
                label: const Text("Lihat Galeri Mahasiswa"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
