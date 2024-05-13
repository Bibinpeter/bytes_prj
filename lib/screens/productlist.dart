import 'package:bytes/model/model.dart';
import 'package:bytes/screens/prolist.dart';
import 'package:bytes/service/apiservice.dart';
import 'package:flutter/material.dart';

class getProductsListing extends StatefulWidget {
  const getProductsListing({super.key});

  @override
  State<getProductsListing> createState() => _getProductsListingState();
}

class _getProductsListingState extends State<getProductsListing> {
  ApiService apiService = ApiService();
  final _scrollcontroller = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(_currentPage);
    _scrollcontroller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
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
      // Handle error gracefully (e.g., show a snackbar)
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollcontroller.position.pixels >=
            _scrollcontroller.position.maxScrollExtent &&
        !_isLoading) {
      _loadProducts(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  controller: _scrollcontroller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < _products.length) {
                      // Assuming Product is the model for your products
                      Product product = Product.fromJson(_products[index]);
                      return ProductTile(product: product);
                    } else {
                      return   CircularProgressIndicator();
                    }
                  }))
        ],
      ),
    );
  }

  
}
