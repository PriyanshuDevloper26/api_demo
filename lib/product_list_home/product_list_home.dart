import 'package:api_demo/api_helpers/network_constants.dart';
import 'package:api_demo/common_widget/common_app_image.dart';
import 'package:api_demo/product_details/product_detail.dart';
import 'package:api_demo/product_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingData
                ? const CircularProgressIndicator()
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
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetails(id: item.id ?? 0),
                                  ),
                                ),
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
                                            initialRating: item.rating?.rate.runtimeType == double
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
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                ),
                                                Card(
                                                  color: Colors.red,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 3),
                                                    child: Text(
                                                      '₹${item.price ?? 0}',
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
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
