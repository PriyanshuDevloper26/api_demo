import '../models/add_to_cart_model.dart';

class AppClass {
  static final AppClass _singleton = AppClass._internal();

  factory AppClass() {
    return _singleton;
  }

  AppClass._internal();

  bool isShowLoading = false;

  void showLoading(bool value) {
    isShowLoading = value;
  }

  List<AddToCartModel> productCartList = [];
}
