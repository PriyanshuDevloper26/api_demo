import 'package:api_demo/api_helpers/network_constants.dart';
import 'package:api_demo/app/app_class.dart';
import 'package:api_demo/app/app_images.dart';
import 'package:api_demo/common_widget/common_app_image.dart';
import 'package:api_demo/common_widget/common_app_shimmer.dart';
import 'package:api_demo/common_widget/common_loading_widget.dart';
import 'package:api_demo/models/add_to_cart_model.dart';
import 'package:api_demo/models/product_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'dart:math' as math;

extension StringExtension on String {
  String toCapitalized() {
    return length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  }

  String toTitleCase() {
    return replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  }
}

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool loadingData = false;
  Dio dioClient = Dio();

  int quantity = 1;

  ProductDetailModel productDetailModel = ProductDetailModel();

  Future<void> getPostList() async {
    try {
      setState(() {
        loadingData = true;
      });

      var response = await dioClient.get(
        "${NetworkConstants.baseUrl}${NetworkConstants.productUrl}${widget.id}",
      );

      setState(() {
        productDetailModel = ProductDetailModel.fromJson(response.data);
        loadingData = false;
      });
    } catch (e, s) {
      setState(() => loadingData = false);
      debugPrint(s.toString());
    }
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
      body: loadingData
          ? loadingWidget()
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: kToolbarHeight),
                        padding: const EdgeInsets.all(30),
                        child: CommonAppImage(
                          imagePath: productDetailModel.image ?? AppImages.icProduct,
                          fit: BoxFit.contain,
                          height: productDetailModel.image != null && productDetailModel.image != ""
                              ? null
                              : MediaQuery.of(context).size.width / 2,
                          width: productDetailModel.image != null && productDetailModel.image != ""
                              ? null
                              : MediaQuery.of(context).size.width / 2,
                        ),
                      ),
                      Positioned(
                        left: 25,
                        top: kToolbarHeight + 10,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: kToolbarHeight + 5,
                        child: Stack(
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
                                color: Theme.of(context).primaryColor,
                                icon: const Icon(
                                  Icons.shopping_cart,
                                ),
                              ),
                            ),
                            if (AppClass().productCartList.isNotEmpty)
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(AppClass().productCartList.length > 9 ? 4 : 5),
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                    height: 0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (productDetailModel.category != null)
                                    Expanded(
                                      child: Text(
                                        productDetailModel.category.toString().toCapitalized(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
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
                                    allowHalfRating: true,
                                    updateOnDrag: false,
                                    initialRating:
                                        productDetailModel.rating?.rate?.runtimeType == double
                                            ? productDetailModel.rating?.rate ?? 0
                                            : double.parse(
                                                '${productDetailModel.rating?.rate ?? 0}',
                                              ),
                                    minRating: 1,
                                    ignoreGestures: true,
                                    onRatingUpdate: (double value) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (productDetailModel.title != null)
                                Text(
                                  productDetailModel.title.toString().toCapitalized(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        _incrementDecrementButton(
                                          context: context,
                                          icon: CupertinoIcons.minus_square,
                                          onTap: quantity > 1
                                              ? () {
                                                  setState(() {
                                                    quantity--;
                                                  });
                                                }
                                              : null,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        _incrementDecrementButton(
                                          context: context,
                                          icon: CupertinoIcons.plus_square,
                                          onTap: quantity < 10
                                              ? () => setState(() => quantity++)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 700),
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: (double.tryParse(
                                                  (productDetailModel.price ?? 0.0).toString()) ??
                                              0.0) *
                                          quantity,
                                    ),
                                    builder: (BuildContext context, double value, Widget? child) {
                                      return Text(
                                        "\$ ${value.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.green,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (productDetailModel.description != null)
                                ReadMoreText(
                                  productDetailModel.description.toString().toCapitalized(),
                                  trimLines: 3,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: ' Show less',
                                  moreStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  lessStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      AddToCartModel dataToAdd = AddToCartModel(
                        id: productDetailModel.id ?? 0,
                        image: productDetailModel.image ?? AppImages.icProduct,
                        title: productDetailModel.title ?? '',
                        description: productDetailModel.description ?? '',
                        category: productDetailModel.category ?? '',
                        price: productDetailModel.price != 0.0 || productDetailModel.price != 0
                            ? productDetailModel.price * quantity
                            : 0.0,
                        quantity: quantity,
                        rating: productDetailModel.rating?.rate ?? 0.0,
                      );
                      setState(() {
                        AppClass().productCartList.add(dataToAdd);
                      });
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 0),
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.black, strokeAlign: 7),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget loadingWidget() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: kToolbarHeight),
                padding: const EdgeInsets.all(30),
                child: const CommonLoadingWidget(),
              ),
              Positioned(
                left: 25,
                top: kToolbarHeight + 10,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: kToolbarHeight + 5,
                child: Stack(
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
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(
                          Icons.shopping_cart,
                        ),
                      ),
                    ),
                    if (AppClass().productCartList.isNotEmpty)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding:
                          EdgeInsets.all(AppClass().productCartList.length > 9 ? 4 : 5),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            thickness: 1,
            color: Theme.of(context).dividerColor,
            height: 0,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CommonAppShimmer.rectangular(
                            height: 15,
                            width: MediaQuery.of(context).size.width / 3.5,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const Spacer(),
                          CommonAppShimmer.rectangular(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 2.5,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      _height15(),
                      CommonAppShimmer.rectangular(
                        height: 20,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      _height10(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CommonAppShimmer.rectangular(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CommonAppShimmer.rectangular(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 4,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      _height15(),
                      _commonAppShimmerText(),
                      _height10(),
                      _commonAppShimmerText(),
                      _height10(),
                      _commonAppShimmerText(),
                      _height10(),
                      CommonAppShimmer.rectangular(
                        height: 15,
                        width: MediaQuery.of(context).size.width / 2,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: CommonAppShimmer.rectangular(
            height: 70,
            width: MediaQuery.of(context).size.width,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _height15() => const SizedBox(height: 15);

  CommonAppShimmer _commonAppShimmerText() {
    return CommonAppShimmer.rectangular(
      height: 15,
      width: MediaQuery.of(context).size.width,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  SizedBox _height10() => const SizedBox(height: 10);

  IconButton _incrementDecrementButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      disabledColor: Theme.of(context).primaryColor,
      visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
      padding: EdgeInsets.zero,
      iconSize: 35,
      splashRadius: 25,
      color: Theme.of(context).primaryColor,
      icon: Icon(icon),
    );
  }
}
