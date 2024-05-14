import 'package:bytes/model/model.dart';
import 'package:bytes/widget/animatedcard.dart';
import 'package:flutter/material.dart';

class gridWiew extends StatelessWidget {
  final List products;
   
  final Function(String, String,String,) onItemTap;

  const gridWiew({
    Key? key,
    required this.products,
    required this.onItemTap,
      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < products.length) {
            Product product = Product.fromJson(products[index]);
            return GestureDetector(
              onTap: () => onItemTap(product.imageUrl, product.title, product.price.toString(),),
              child: AnimationCard(product: product),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
