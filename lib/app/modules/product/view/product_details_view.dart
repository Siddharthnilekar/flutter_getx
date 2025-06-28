import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import '../models/product_model.dart';
import 'dart:developer' as developer;

class ProductDetailsView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ProductModel? product = Get.arguments;

  ProductDetailsView({super.key}) {
    // Log arguments for debugging
    developer.log(
      'ProductDetailsView arguments: $product',
      name: 'ProductDetailsView',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('product_details'.tr)),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('product_details'.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Obx(
              () => Badge(
                isLabelVisible: cartController.cartItems.isNotEmpty,
                label: Text(
                  cartController.cartItems.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: Colors.red,
                offset: const Offset(
                  -4,
                  -4,
                ), // Shifts badge slightly left and up
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'view_cart'.tr,
                  onPressed: () => Get.toNamed('/cart'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent:
                    ModalRoute.of(context)!.animation ??
                    const AlwaysStoppedAnimation(1.0),
                curve: Curves.easeOut,
              ),
            ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  product!.image,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 100),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product!.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${'price'.tr}: \$${product!.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 8),
              Text(
                '${'category'.tr}: ${product!.category}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${'rating'.tr}: ${product!.rating.rate} (${product!.rating.count ?? 0} ${'reviews'.tr})',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(product!.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              AnimatedButton(
                text: 'add_to_cart'.tr,
                onPressed: () {
                  cartController.addToCart(product!);
                  Get.snackbar(
                    'added_to_cart'.tr,
                    '${product!.title} ${'added_to_cart_message'.tr}',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
              AnimatedButton(
                text: 'more_actions'.tr,
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.shopping_cart),
                            title: Text('view_cart'.tr),
                            onTap: () => Get.toNamed('/cart'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.payment),
                            title: Text('proceed_to_checkout'.tr),
                            onTap: () => Get.toNamed('/checkout'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              child: Text(widget.text),
            ),
          );
        },
      ),
    );
  }
}
