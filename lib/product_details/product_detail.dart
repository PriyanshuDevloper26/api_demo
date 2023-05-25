import 'dart:ui';

import 'package:api_demo/api_helpers/network_constants.dart';
import 'package:api_demo/common_widget/common_app_image.dart';
import 'package:api_demo/product_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

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
    } catch (e) {
      setState(() => loadingData = false);
      debugPrint(e.toString());
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
      body: Column(
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
                    imagePath: productDetailModel.image ?? "assets/images/ic_full_star.png",
                    fit: BoxFit.contain,
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
                              initialRating: productDetailModel.rating?.rate?.runtimeType == double
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
                                    onTap: quantity < 10 ? () => setState(() => quantity++) : null,
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
                                  "₹ ${value.toStringAsFixed(2)}",
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
              onPressed: () {},
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

//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.green,
//     appBar: AppBar(
//       title: const Text('Details'),
//     ),
//     body: Card(
//       margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
//       elevation: 0,
//       shape: const RoundedRectangleBorder(
//         side: BorderSide(color: Colors.white, width: 3),
//       ),
//       color: Colors.white.withOpacity(0.5),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 3,
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   child: Card(
//                     elevation: 10,
//                     margin: const EdgeInsets.all(15),
//                     child: CommonAppImage(
//                       imagePath: productDetailModel.image ?? "assets/images/ic_full_star.png",
//                       height: 40,
//                       width: 40,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   right: 20,
//                   child: Text(
//                     " ₹${productDetailModel.price ?? 0}",
//                     style: TextStyle(
//                       color: (productDetailModel.price ?? 0) >= 50 ? Colors.red : Colors.blue,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Text(
//                 productDetailModel.title ?? '-',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Text(
//                 productDetailModel.description ?? '-',
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: RatingBar(
//                       ratingWidget: RatingWidget(
//                         full: const Icon(
//                           Icons.star,
//                           color: Colors.orangeAccent,
//                         ),
//                         half: const Icon(
//                           Icons.star_half,
//                           color: Colors.orangeAccent,
//                         ),
//                         empty: const Icon(
//                           Icons.star_border,
//                           color: Colors.orangeAccent,
//                         ),
//                       ),
//                       itemCount: 5,
//                       allowHalfRating: true,
//                       updateOnDrag: false,
//                       initialRating: productDetailModel.rating?.rate?.runtimeType == double
//                           ? productDetailModel.rating?.rate ?? 0
//                           : double.parse(
//                               '${productDetailModel.rating?.rate ?? 0}',
//                             ),
//                       minRating: 1,
//                       ignoreGestures: true,
//                       onRatingUpdate: (double value) {},
//                     ),
//                   ),
//                   Text(
//                     "(${productDetailModel.rating?.count ?? 0})",
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Text(
//               "Category: ${productDetailModel.category ?? '-'}",
//               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
