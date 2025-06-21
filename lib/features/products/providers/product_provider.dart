import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/products/models/product_model.dart';

final productProvider =
    FutureProvider.family<Product, DocumentReference>((ref, productRef) async {
  final snapshot = await productRef.get();
  if (!snapshot.exists) {
    throw Exception('El producto no existe.');
  }
  final data = snapshot.data() as Map<String, dynamic>;
  return Product.fromMap(data);
});
