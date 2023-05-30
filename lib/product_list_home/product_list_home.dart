import 'package:animations/animations.dart';
import 'package:api_demo/api_helpers/network_constants.dart';
import 'package:api_demo/app/app_class.dart';
import 'package:api_demo/common_widget/common_app_image.dart';
import 'package:api_demo/common_widget/common_app_shimmer.dart';
import 'package:api_demo/product_details/product_detail.dart';
import 'package:api_demo/models/product_list_model.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' as math;

import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductListHome extends StatefulWidget {
  const ProductListHome({super.key});

  @override
  State<ProductListHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProductListHome> {
  List<ProductListModel> productList = [];
  bool loadingData = false;
  Dio dioClient = Dio();

  Future<void> getPostList() async {
    setState(() {
      loadingData = true;
    });
    var response = await dioClient.get("${NetworkConstants.baseUrl}${NetworkConstants.productUrl}");
    List<dynamic> dynamicList = response.data;

    setState(() {
      productList = dynamicList.map((e) => ProductListModel.fromJson(e)).toList();
      loadingData = false;
    });
  }

  @override
  void initState() {
    getPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Home Page"),
        shadowColor: Colors.red,
        foregroundColor: Colors.red,
        actions: [
          Stack(
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: IconButton(
                  onPressed: () {
                    debugPrint("Data :: ${AppClass().productCartList.length}");
                  },
                  visualDensity: const VisualDensity(vertical: 0),
                  iconSize: 30,
                  splashRadius: 25,
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                ),
              ),
              if (AppClass().productCartList.isNotEmpty)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(AppClass().productCartList.length > 9 ? 4 : 5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                    ),
                    child: Text(
                      AppClass().productCartList.length > 9
                          ? '9+'
                          : "${AppClass().productCartList.length}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: AppClass().productCartList.length > 9 ? 12 : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: () {
          getPostList();
          return Future.value();
        },
        onStateChanged: (state) {
          if (state.currentState == IndicatorState.armed) {
            Future.delayed(
              Duration(seconds: 1),
              () {
                getPostList();
              },
            );
          }
        },
        builder: (BuildContext context, Widget child, IndicatorController controller) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              if (!controller.isIdle)
                Positioned(
                  top: 35.0 * controller.value,
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).primaryColor,
                      size: 35,
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, 100.0 * controller.value),
                child: child,
              ),
            ],
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loadingData
                  ? loadingWidget()
                  : productList.isEmpty
                      ? const Text("No data")
                      : Expanded(
                          child: ListView.builder(
                            itemCount: productList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = productList[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: OpenContainer(
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue}) action) {
                                    return ProductDetails(id: item.id ?? 0);
                                  },
                                  transitionDuration: const Duration(milliseconds: 650),
                                  useRootNavigator: true,
                                  clipBehavior: Clip.none,
                                  closedElevation: 0,
                                  openElevation: 0,
                                  tappable: false,
                                  closedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  openShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onClosed: (_) => setState(() {}),
                                  closedBuilder: (BuildContext context, void Function() action) {
                                    return InkWell(
                                      onTap: action,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                // Image.network(
                                                //   item.image!,
                                                //   width: 80,
                                                //   height: 80,
                                                //   fit: BoxFit.contain,
                                                // ),
                                                CommonAppImage(
                                                  imagePath: item.image!,
                                                  height: 80,
                                                  width: 80,
                                                  isCircular: true,
                                                  fit: BoxFit.contain,
                                                ),
                                                RatingBar(
                                                  ratingWidget: RatingWidget(
                                                    full: const Icon(
                                                      Icons.star,
                                                      color: Colors.orangeAccent,
                                                    ),
                                                    half: const Icon(
                                                      Icons.star_half,
                                                      color: Colors.orangeAccent,
                                                    ),
                                                    empty: const Icon(
                                                      Icons.star_border,
                                                      color: Colors.orangeAccent,
                                                    ),
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  allowHalfRating: true,
                                                  initialRating:
                                                      item.rating?.rate.runtimeType == double
                                                          ? item.rating?.rate
                                                          : double.parse(
                                                              item.rating!.rate.toString(),
                                                            ),
                                                  minRating: 1,
                                                  onRatingUpdate: (double value) {},
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title ?? 'No Title',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    item.description ?? 'No Description',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Category: ${item.category ?? 'No Category'}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style:
                                                              const TextStyle(color: Colors.grey),
                                                        ),
                                                      ),
                                                      Card(
                                                        color: Colors.red,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 8, vertical: 3),
                                                          child: Text(
                                                            '\$${item.price ?? 0}',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      // Image.network(
                      //   item.image!,
                      //   width: 80,
                      //   height: 80,
                      //   fit: BoxFit.contain,
                      // ),
                      CommonAppShimmer.rectangular(
                        height: 80,
                        width: 80,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5),
                      CommonAppShimmer.rectangular(
                        height: 15,
                        width: 80,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonAppShimmer.rectangular(
                          height: 15,
                          width: MediaQuery.of(context).size.width / 2.5,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CommonAppShimmer.rectangular(
                          height: 10,
                          width: MediaQuery.of(context).size.width,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CommonAppShimmer.rectangular(
                          height: 11,
                          width: MediaQuery.of(context).size.width / 2,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CommonAppShimmer.rectangular(
                                height: 20,
                                width: 10,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              child: CommonAppShimmer.rectangular(
                                height: 20,
                                width: 80,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
