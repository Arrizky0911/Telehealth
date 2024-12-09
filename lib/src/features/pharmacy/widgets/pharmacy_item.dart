import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int cartQuantity;
  final VoidCallback onAddToCart;
  final Function(int) onUpdateQuantity;
  final Function() onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartQuantity,
    required this.onAddToCart,
    required this.onUpdateQuantity,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(product.price).replaceAll(',', '.')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    if (cartQuantity == 0)
                      _buildAddButton(context)
                    else
                      _buildQuantityCounter(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Material(
      color: const Color(0xFFFF4081),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onAddToCart,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityCounter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF4081),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => onUpdateQuantity(cartQuantity - 1),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$cartQuantity',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () => onUpdateQuantity(cartQuantity + 1),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

