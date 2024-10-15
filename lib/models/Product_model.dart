import 'dart:convert';

productModel welcomeFromJson(String str) =>
    productModel.fromJson(json.decode(str));

String welcomeToJson(productModel data) => json.encode(data.toJson());

class productModel {
  String id;
  String productName;
  String productType;
  int price;
  String unit;

  productModel({
    required this.id,
    required this.productName,
    required this.productType,
    required this.price,
    required this.unit,
  });

  factory productModel.fromJson(Map<String, dynamic> json) => productModel(
        id: json["_id"],
        productName: json["product_name"],
        productType: json["product_type"],
        price: json["price"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit,
      };
}
