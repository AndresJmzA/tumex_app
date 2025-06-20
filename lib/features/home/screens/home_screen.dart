import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/auth/services/auth_service.dart';
import 'package:tumex_users_app/features/profile/services/profile_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Mock list of orders. Start with an empty list to show the placeholder.
  final List<Map<String, String>> _openOrders = [];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page?.round() != _currentPage) {
          _currentPage = _pageController.page!.round();
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(firebaseAuthProvider);
    final uid = authState.currentUser?.uid;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Welcome Section
                if (uid != null)
                  ref.watch(userProvider(uid)).when(
                        data: (user) {
                          final lastName = user?.lastName ?? '';
                          return Row(
                            children: [
                              Image.asset(
                                'assets/images/tumex_logo.png',
                                height: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.business, size: 50),
                              ),
                              const SizedBox(width: 16),
                              RichText(
                                text: TextSpan(
                                  // Default style for the entire RichText
                                  style: Theme.of(context).textTheme.titleLarge,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Bienvenido ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Dr. $lastName',
                                      // This will inherit titleLarge style but without bold/color override
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => Center(
                          child: Text('Error: ${error.toString()}'),
                        ),
                      ),
                const SizedBox(height: 24),

                // -- Services Section
                Text(
                  'Servicios',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _ServiceCard(
                  title: 'Paquetes para Cirugías',
                  imagePath: 'assets/images/surgery_package.png',
                  height: 180,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _ServiceCard(
                  title: 'Renta de equipo y Venta de insumos',
                  imagePath: 'assets/images/rent_sell_equipment.png',
                  height: 120,
                  onTap: () {},
                ),
                const SizedBox(height: 24),

                // -- Open Orders Section
                Text(
                  'Ordenes Abiertas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Check if there are open orders
                if (_openOrders.isEmpty)
                  _buildEmptyOrdersPlaceholder(context)
                else
                  _buildOrdersPageView(context),

                const SizedBox(height: 24),

                // -- Other sections will be added here later
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for the PageView and its indicators
  Widget _buildOrdersPageView(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _openOrders.length,
            itemBuilder: (context, index) {
              final order = _openOrders[index];
              return _OrderCard(
                orderId: order['id']!,
                orderStatus: order['status']!,
                arrivalTime: order['arrival']!,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_openOrders.length, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
              ),
            );
          }),
        ),
      ],
    );
  }

  // Placeholder for when there are no open orders
  Widget _buildEmptyOrdersPlaceholder(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay órdenes abiertas por el momento',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }
}

// Reusable widget for the service cards
class _ServiceCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double height;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.imagePath,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior:
            Clip.antiAlias, // Ensures the image respects the border radius
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Background Image
            Image.asset(
              imagePath,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder in case of image loading error
                return Container(
                  height: height,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
            // Gradient Overlay
            Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable widget for the order cards
class _OrderCard extends StatelessWidget {
  final String orderId;
  final String orderStatus;
  final String arrivalTime;

  const _OrderCard({
    required this.orderId,
    required this.orderStatus,
    required this.arrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info
            Text('Order Número: $orderId',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Estatus: $orderStatus',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Hora de Llegada: $arrivalTime',
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            // Lottie Animation
            Center(
              child: Lottie.asset(
                'assets/lottie/order_box.json',
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                    size: 40,
                  );
                },
              ),
            ),
            const Spacer(),
            // View Order Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Ver Orden'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
