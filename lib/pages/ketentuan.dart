import 'package:flutter/material.dart';

class KetentuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketentuan Penggunaan',   style: TextStyle(
                    color: Colors.white,),),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Text(
                  '1.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  'Penggunaan aplikasi FrameFit hanya untuk membantu pengguna memilih bingkai kacamata yang sesuai berdasarkan bentuk wajah mereka.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Text(
                  '2.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  'Aplikasi ini tidak menjamin bahwa bingkai yang direkomendasikan akan sepenuhnya sesuai atau memuaskan pengguna. Keputusan akhir tetap berada di pihak pengguna.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Text(
                  '3.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  'Dilarang menggunakan aplikasi ini untuk tujuan komersial tanpa izin tertulis dari pengembang.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Text(
                  '4.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  'Pengguna bertanggung jawab penuh atas penggunaan aplikasi dan hasil yang diperoleh.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
