import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  double? price;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? category;

  @HiveField(5)
  String? image;

  @HiveField(6)
  Rating? rating;



  ProductModel(
      {this.id,
        this.title,
        this.price,
        this.description,
        this.category,
        this.image,
        this.rating});

  ProductModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price =     price = (json['price'] is int)
        ? (json['price'] as int).toDouble()
        : (json['price'] as num?)?.toDouble();
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating =
    json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }

}

@HiveType(typeId: 1)
class Rating {
  @HiveField(0)
  double? rate;

  @HiveField(1)
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<dynamic, dynamic> json) {
    rate = (json['rate'] is int)
        ? (json['rate'] as int).toDouble()
        : (json['rate'] as num?)?.toDouble();;
    count = json['count'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}
