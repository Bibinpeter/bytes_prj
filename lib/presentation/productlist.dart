import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:bytes/functions/function.dart';
import 'package:bytes/service/apiservice.dart';
import 'package:bytes/widget/carosel.dart';
import 'package:bytes/widget/gridview.dart';
import 'package:bytes/widget/refresh.dart';
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
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts(_currentPage);
  }

  @override
  void dispose() {
    textController.dispose();
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
      appBar: AppBar(
        title: const Text("Products List",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: AnimSearchBar(
              color: Colors.blueGrey,
              textFieldIconColor: Colors.amberAccent,
              helpText: "find keyword",
              width: 270,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
              onSubmitted: (String val) async {
                setState(() {
                  // Add your search logic here
                });
              },
            ),
          ),
        ],
      ),
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
                gridWiew(
                  products: _products,
                  onItemTap: (imageUrl, description, price) => showProductBottomSheet(context, imageUrl, price, description),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
