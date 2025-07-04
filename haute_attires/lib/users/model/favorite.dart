class Favorite {
  int? favorite_id;
  int? user_id;
  int? item_id;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;
  List<String>? categories;
  double? offer;
  // int? stock;
  double? actualprice;

  Favorite({
    this.favorite_id,
    this.user_id,
    this.item_id,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.sizes,
    this.colors,
    this.description,
    this.image,
    this.categories,
    this.offer,
    // this.stock,
    this.actualprice,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favorite_id: json['favorite_id'] != null ? int.tryParse(json['favorite_id'].toString()) : null,
        user_id: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
        item_id: json['item_id'] != null ? int.tryParse(json['item_id'].toString()) : null,
        name: json['name'] ?? "", // Provide a default value if null
        rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : 0.0,
        tags: json['tags'] != null ? json['tags'].toString().split(', ') : [],
        price: json['price'] != null ? double.tryParse(json['price'].toString()) : 0.0,
        sizes: json['sizes'] != null ? json['sizes'].toString().split(', ') : [],
        colors: json['colors'] != null ? json['colors'].toString().split(', ') : [],
        description: json['description'] ?? "",
        image: json['image'] ?? "", // Provide a default value if null
        categories: json["categories"] != null ? json["categories"].toString().split(",") : [],
        offer: double.tryParse(json["offer"].toString()) ?? 0.0,
        actualprice: double.tryParse(json["actualprice"].toString()) ?? 0.0,
        // stock: int.tryParse(json["stock"].toString()) ?? 0,
      );
}
