import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/procedures/models/order_draft_model.dart';
import 'package:tumex_users_app/features/procedures/providers/order_draft_provider.dart';
import 'package:tumex_users_app/features/products/models/product_model.dart';

// Provider to get all products grouped by category with their document references
final productsByCategoryProvider =
    StreamProvider<Map<String, List<MapEntry<Product, DocumentReference>>>>(
        (ref) {
  return FirebaseFirestore.instance
      .collection('Products')
      .snapshots()
      .map((snapshot) {
    final Map<String, List<MapEntry<Product, DocumentReference>>>
        groupedProducts = {};

    for (final doc in snapshot.docs) {
      final product = Product.fromMap(doc.data());
      final category = doc.data()['category'] ?? 'Sin categoría';

      if (!groupedProducts.containsKey(category)) {
        groupedProducts[category] = [];
      }
      groupedProducts[category]!.add(MapEntry(product, doc.reference));
    }

    return groupedProducts;
  });
});

class AddItemsScreen extends ConsumerWidget {
  const AddItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Productos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Listo'),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (groupedProducts) {
          if (groupedProducts.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles'),
            );
          }

          return ListView.builder(
            itemCount: groupedProducts.length,
            itemBuilder: (context, index) {
              final category = groupedProducts.keys.elementAt(index);
              final products = groupedProducts[category]!;

              return ExpansionTile(
                title: Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                children: products.map((productEntry) {
                  return _ProductCard(
                    product: productEntry.key,
                    productRef: productEntry.value,
                  );
                }).toList(),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final Product product;
  final DocumentReference productRef;

  const _ProductCard({
    required this.product,
    required this.productRef,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            product.imageUrl ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.image_not_supported, size: 50),
          ),
        ),
        title: Text(product.name),
        trailing: ElevatedButton(
          onPressed: () {
            // Create an ItemInCart and add it to the order draft
            final newItem = ItemInCart(
              itemID: productRef,
              defaultQuantity: 1,
              category: 'General',
              isDefault: false,
              fromTemplateItem: false,
              choiceGroup: null,
            );

            ref.read(orderDraftProvider.notifier).addItem(newItem);

            // Show feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} añadido al carrito'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Añadir'),
        ),
      ),
    );
  }
}
