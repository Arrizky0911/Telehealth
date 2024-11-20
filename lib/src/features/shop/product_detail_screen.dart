import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'shop_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key, 
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_outlined, size: 80, color: Colors.grey),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Price
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(product.price).replaceAll(',', '.')}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C6BC0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tabs
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Ingredients'),
                            Tab(text: 'Description'),
                          ],
                          labelColor: Color(0xFF5C6BC0),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Color(0xFF5C6BC0),
                        ),
                        SizedBox(
                          height: 100,
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  product.description,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'Able to increase moisture without causing stickiness. The texture is gentle, fragrance-free, and does not cause irritation on the face',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5C6BC0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Get Product'),
        ),
      ),
    );
  }
}