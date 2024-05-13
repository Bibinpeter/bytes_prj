class Product {
  // final String id;
  final String title;
  final String imageUrl;
  final int price;
  final String type;

  Product({
      // required this.id,
      required this.title,
      required this.imageUrl,
      required this.price,
      required this.type
      });

       factory Product.fromJson(Map<String, dynamic> json) => Product(
 
        title: json['title'],
        imageUrl: json['image'],
        type: json['type'],
        price: json['price'] ,
      );
}
