import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán las notificaciones.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
