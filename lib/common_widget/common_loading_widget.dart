import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommonLoadingWidget extends StatelessWidget {
  const CommonLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      "assets/animation/product_widget_animation.json",
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width / 1.8,
      height: MediaQuery.of(context).size.width / 1.8,
    );
  }
}
