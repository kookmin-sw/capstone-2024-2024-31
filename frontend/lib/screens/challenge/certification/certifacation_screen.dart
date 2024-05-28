import 'package:flutter/material.dart';
import 'certification_camera.dart';



class CertifacationScreen extends StatefulWidget {
  const CertifacationScreen({super.key});

  @override
  State<CertifacationScreen> createState() => _ChooseDemoState();
}

class _ChooseDemoState extends State<CertifacationScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('정해진 자세를 취해주세요!'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CertificationCamera()),
                    )
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "카메라",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => {

                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "갤러리",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
