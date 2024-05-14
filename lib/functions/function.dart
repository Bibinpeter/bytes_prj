import 'package:bytes/widget/linearbutton.dart';
import 'package:flutter/material.dart';

void showProductBottomSheet(
  BuildContext context,
  String imageUrl,
   String Price,
  
  String description,
) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent, // Use transparent background to avoid color overlap
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 900,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     
                    const SizedBox(height: 8),
                  
                    Text(
                     "₹ $Price" ,
                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                     textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),    // Elevated Button
                   const GradientButton(text: "BUY  NOW",)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
