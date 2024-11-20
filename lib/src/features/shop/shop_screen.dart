import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/shop/product_detail_screen.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
  });
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _isLoading = false;
  Timer? _debounce;
  List<Product> _filteredProducts = [];

  void _filterProducts() {
    setState(() => _isLoading = true);
    
    _filteredProducts = products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final matchesCategory = selectedCategory == 'All' || 
                           product.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    
    setState(() => _isLoading = false);
  }

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Gentle Facial Wash',
      price: 150000,
      imageUrl: 'https://example.com/facial-wash.jpg',
      description: 'Gentle facial wash for daily use',
      category: 'Cleanser',
    ),
    Product(
      id: '2',
      name: 'Hydrating Moisturizer',
      price: 200000,
      imageUrl: 'https://example.com/moisturizer.jpg',
      description: 'Deep hydration for all skin types',
      category: 'Moisturizer',
    ),
  ];

  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<Product> get filteredProducts {
    setState(() => _isLoading = true);

    final filtered = products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final matchesCategory = selectedCategory == 'All' ||
                              product.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    setState(() => _isLoading = false);
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _filterProducts(); // Initial filter
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterProducts();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              automaticallyImplyLeading: false,
              title: const Text(
                'Skincare Shop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
              ],
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),

            // Search & Filter
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 120,
                maxHeight: 120,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Search
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Categories
                      SizedBox(
                        height: 35,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            'All',
                            'Cleanser',
                            'Toner',
                            'Serum',
                            'Moisturizer',
                            'Sunscreen'
                          ].map((category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: selectedCategory == category 
                                    ? Colors.white 
                                    : Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                              selected: selectedCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = category;
                                  _filterProducts();
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: const Color(0xFF5C6BC0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: selectedCategory == category
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              showCheckmark: false,
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _isLoading 
                ? const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _filteredProducts.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = _filteredProducts[index];
                          return _buildProductCard(product);
                        },
                        childCount: _filteredProducts.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(product.price).replaceAll(',', '.')}',
                    style: const TextStyle(
                      color: Color(0xFF5C6BC0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
