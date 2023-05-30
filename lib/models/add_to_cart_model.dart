// ignore_for_file: prefer_typing_uninitialized_variables

class AddToCartModel {
  String? image;
  String? category;
  String? title;
  String? description;
  var rating;
  var price;
  int? quantity;
  int? id;

  AddToCartModel({
    this.id,
    this.image,
    this.category,
    this.title,
    this.description,
    this.rating,
    this.price,
    this.quantity,
  });
}
