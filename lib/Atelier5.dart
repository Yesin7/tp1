import 'package:flutter/material.dart';

// Model class
class Product {
  final String name;
  final double price;
  final String image; // chemin d'asset
  final bool isNew;
  final double rating;
  final String description;
  final Map<String, String> specifications;

  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
    required this.description,
    required this.specifications,
  });
}

class ProductListPageM5 extends StatefulWidget {
  const ProductListPageM5({super.key});

  @override
  State<ProductListPageM5> createState() => _ProductListPageM5State();
}

class _ProductListPageM5State extends State<ProductListPageM5> {
  final List<Product> products = const [
    Product(
      'iPhone 15',
      999.0,
      'assets/images/iphone-15.jpg',
      isNew: true,
      rating: 4.5,
      description:
          'Découvrez le iPhone 15, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées.',
      specifications: {
        'Écran': '6.1 pouces Super Retina XDR',
        'Processeur': 'A16 Bionic',
        'Mémoire': '128 GB',
        'Batterie': 'Jusqu\'à 20h de vidéo',
      },
    ),
    Product(
      'Samsung Galaxy',
      799.0,
      'assets/images/samsung.jpg',
      isNew: false,
      rating: 4.2,
      description:
          'Samsung Galaxy: performance et polyvalence. Idéal pour la photo et le multitâche.',
      specifications: {
        'Écran': '6.4 pouces AMOLED',
        'Processeur': 'Exynos / Snapdragon',
        'Mémoire': '128 GB',
        'Batterie': 'Jusqu\'à 22h',
      },
    ),
    Product(
      'Google Pixel',
      699.0,
      'assets/images/google.jpg',
      isNew: true,
      rating: 4.7,
      description:
          'Google Pixel: Android pur, appareil photo de haute qualité et mises à jour rapides.',
      specifications: {
        'Écran': '6.1 pouces OLED',
        'Processeur': 'Google Tensor',
        'Mémoire': '128 GB',
        'Batterie': 'Jusqu\'à 18h',
      },
    ),
  ];

  // Panier: map product -> quantity
  final Map<Product, int> cart = {};

  // Gérer quel index est développé (pour animer la flèche)
  int? expandedIndex;

  void addToCart(Product product) {
    setState(() {
      cart.update(product, (q) => q + 1, ifAbsent: () => 1);
    });
    // Optionnel : petit feedback
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} ajouté au panier')),
    );
  }

  int get totalItems =>
      cart.values.fold(0, (previousValue, element) => previousValue + element);

  double get totalPrice {
    double total = 0.0;
    cart.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  void showCartSummary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Récapitulatif Panier',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (cart.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('Votre panier est vide.'),
                )
              else
                Column(
                  children: [
                    // Liste des produits dans le panier
                    ...cart.entries.map((entry) {
                      final p = entry.key;
                      final q = entry.value;
                      return ListTile(
                        leading: SizedBox(
                          width: 48,
                          height: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(p.image, fit: BoxFit.cover),
                          ),
                        ),
                        title: Text(p.name),
                        subtitle: Text('Quantité: $q'),
                        trailing:
                            Text('${(p.price * q).toStringAsFixed(2)}€'),
                      );
                    }).toList(),
                    const Divider(),
                    // total
                    ListTile(
                      title: Text(
                        'Total (${totalItems} articles)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${totalPrice.toStringAsFixed(2)}€',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              // Bouton fermer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Pour afficher la flèche animée selon l'état d'expansion
  Widget buildTrailing(int index, Product product) {
    final isExpanded = expandedIndex == index;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // bouton Ajouter au panier (icône)
        IconButton(
          onPressed: () => addToCart(product),
          icon: const Icon(Icons.add_shopping_cart),
        ),
        // icône flèche (manuelle)
        IconButton(
          onPressed: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          icon: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.expand_more),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          // icône panier avec badge
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: showCartSummary,
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 8,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isExpanded = expandedIndex == index;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header (image + infos + actions)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Image + badge NEW
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
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
                      // Nom + note + prix
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
                                const SizedBox(width: 6),
                                Text(product.rating.toString()),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${product.price.toStringAsFixed(0)}€',
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
                      // Actions: ajouter au panier + flèche (gérée par buildTrailing)
                      buildTrailing(index, product),
                    ],
                  ),
                ),

                // Partie expandable : description + specifications
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(product.description),
                        const SizedBox(height: 12),
                        const Text(
                          'Spécifications',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        ...product.specifications.entries.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        e.key,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )),
                                  Expanded(flex: 5, child: Text(e.value)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
