import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFFFFF),
      child: const Center(
        child: SpinKitWave(
          color: Color(0xff5186c3),
          size: 75.0,
        ),
      ),
    );
  }
}