import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFFFFF),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.blue,
          size: 120,
        ),
      ),
    );
  }
}