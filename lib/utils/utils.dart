import 'dart:ui';

import 'package:api_demo/common_widget/common_loading_widget.dart';
import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static Widget loadingWidget() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: const Center(
        child: CommonLoadingWidget(),
      ),
    );
  }
}
