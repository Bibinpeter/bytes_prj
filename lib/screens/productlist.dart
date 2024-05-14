import 'package:bytes/model/model.dart';
import 'package:bytes/service/apiservice.dart';
import 'package:bytes/widget/animatedcard.dart';
import 'package:bytes/widget/refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class getProductsListing extends StatefulWidget {
  const getProductsListing({super.key});

  @override
  State<getProductsListing> createState() => _getProductsListingState();
}

// ignore: camel_case_types
class _getProductsListingState extends State<getProductsListing> {
  ApiService apiService = ApiService();
  int _currentPage = 1;
  bool _isLoading = false;
  final List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(_currentPage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadProducts(int page) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newProducts = await apiService.getProducts(page);
      setState(() {
        _products.addAll(newProducts);
        _isLoading = false;
        _currentPage++;
      });
    } on Exception catch (e) {
      // Handle error gracefully
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WarpIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 2)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _isLoading && _products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : carousel(products: _products),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "All List",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5, // Set a fixed height for GridView
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _products.length) {
                        Product product = Product.fromJson(_products[index]);
                        return AnimationCard(product: product);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
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
