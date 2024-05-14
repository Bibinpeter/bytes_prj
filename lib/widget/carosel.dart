import 'package:bytes/model/model.dart';
import 'package:bytes/widget/animatedcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class carousel extends StatelessWidget {
  const carousel({
    super.key,
    required List products,
  }) : _products = products;

  final List _products;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _products.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        Product product = Product.fromJson(_products[index]);
        return AnimationCard(product: product);
      },
      options: CarouselOptions(
        autoPlayCurve: Curves.easeIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 500),
        height: MediaQuery.of(context).size.height * 0.5,
        autoPlay: true,
        aspectRatio: 16 / 3,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
    );
  }
}
