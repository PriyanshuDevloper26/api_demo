// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:api_demo/common_widget/common_app_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppImage extends StatelessWidget {
  final double? height;
  final double? width;
  final bool isCircular;
  final double? radius;
  final String imagePath;
  final Color? color;
  final BoxFit fit;

  const CommonAppImage(
      {Key? key,
      this.height,
      this.width,
      this.isCircular = false,
      this.radius,
      required this.imagePath,
      this.color,
      this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(radius ?? 0),
      ),
      child: imagePath.isEmpty
          ? const CircularProgressIndicator()
          : imagePath.contains("http")
              ? imagePath.endsWith("svg")
                  ? SvgPicture.network(
                      imagePath,
                      height: height,
                      width: width,
                      color: color,
                      fit: fit,
                      placeholderBuilder: (context) {
                        return CommonAppShimmer.rectangular(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                    )
                  : CachedNetworkImage(
                      imageUrl: imagePath,
                      height: height,
                      width: width,
                      color: color,
                      fit: fit,
                      placeholder: (context, value) {
                        return CommonAppShimmer.rectangular(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                    )
              : imagePath.contains("assets")
                  ? imagePath.endsWith("svg")
                      ? SvgPicture.asset(
                          imagePath,
                          height: height,
                          width: width,
                          color: color,
                          fit: fit,
                        )
                      : Image.asset(
                          imagePath,
                          height: height,
                          width: width,
                          color: color,
                          fit: fit,
                        )
                  : imagePath.endsWith("svg")
                      ? SvgPicture.file(
                          File(imagePath),
                          height: height,
                          width: width,
                          color: color,
                          fit: fit,
                        )
                      : Image.file(
                          File(imagePath),
                          height: height,
                          width: width,
                          color: color,
                          fit: fit,
                        ),
    );
  }
}
