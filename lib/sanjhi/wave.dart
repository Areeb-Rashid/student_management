import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitWave(
        color: Colors.blue,
        type: SpinKitWaveType.center,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
