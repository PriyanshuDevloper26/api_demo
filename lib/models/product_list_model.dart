// ignore_for_file: prefer_typing_uninitialized_variables, duplicate_ignore

class ProductListModel {
  int? id;
  String? title;
  var price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  ProductListModel(
      {this.id, this.title, this.price, this.description, this.category, this.image, this.rating});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['category'] = category;
    data['image'] = image;
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    return data;
  }
}

// ignore: duplicate_ignore, duplicate_ignore
class Rating {
  // ignore: prefer_typing_uninitialized_variables
  var rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['count'] = count;
    return data;
  }
}
