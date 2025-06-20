import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Órdenes'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrará el historial de órdenes.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
