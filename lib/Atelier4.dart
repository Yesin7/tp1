import 'package:flutter/material.dart';
import 'Atelier3.dart';

// Model class
class Product {
  final String name;
  final double price;
  final String image; // chemin d'asset
  final bool isNew;
  final double rating;
  final String description;


  
  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
    required this.description,
    
  });
}

class ProductListPageM4 extends StatelessWidget {
  const ProductListPageM4({super.key});

  final List<Product> products = const [
    Product(
      'iPhone 15',
      999,
      'assets/images/iphone-15.jpg',
      isNew: true,
      rating: 4.5, description: 'IPhone 15 ......',
      
    ),
    Product(
      'Samsung Galaxy',
      799,
      'assets/images/samsung.jpg',
      isNew: false,
      rating: 4.2,description: 'Samsung ......',
    ),
    Product(
      'Google Pixel',
      699,
      'assets/images/google.jpg',
      isNew: true,
      rating: 4.7,description: 'Google ....',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // ➜ Naviguer vers Atelier 3 avec le produit cliqué
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Atelier3Page(product: product),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Image + badge
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              // ✅ utiliser l'image locale
                              image: AssetImage(product.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (product.isNew)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(product.rating.toString()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${product.price}€',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        debugPrint('Ajouter ${product.name} au panier');
                      },
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
