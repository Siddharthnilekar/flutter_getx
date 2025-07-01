import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import 'package:getx_chapter_1/app/services/language_selector.dart';
import '../models/product_model.dart';
import 'dart:developer' as developer;

class ProductDetailsView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ProductModel? product = Get.arguments;
  final GlobalKey cartIconKey = GlobalKey();
  final GlobalKey imageKey = GlobalKey();

  ProductDetailsView({super.key}) {
    developer.log(
      'ProductDetailsView arguments: $product',
      name: 'ProductDetailsView',
    );
  }

  void _addToCartWithAnimation(BuildContext context) {
    if (product == null) return;
    final RenderBox? cartBox =
        cartIconKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? imageBox =
        imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartBox == null || imageBox == null) return;

    final cartPosition = cartBox.localToGlobal(Offset.zero);
    final imagePosition = imageBox.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => AnimatedImageToCart(
        imageUrl: product!.image,
        startPosition: imagePosition,
        endPosition: cartPosition,
        onAnimationComplete: () {
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
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 600), () {
      overlayEntry.remove();
    });
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
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(
              () => Badge(
                isLabelVisible: cartController.cartItems.isNotEmpty,
                label: Text(
                  cartController.cartItems.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: Colors.red,
                offset: const Offset(-4, -4),
                child: IconButton(
                  key: cartIconKey,
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'view_cart'.tr,
                  onPressed: () => Get.toNamed('/cart'),
                ),
              ),
            ),
          ),
          const LanguageSelector(),
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
                child: Hero(
                  tag: 'product-image-${product!.id}',
                  child: Image.network(
                    product!.image,
                    key: imageKey,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100),
                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimatedButton(
                      text: 'add_to_cart'.tr,
                      onPressed: () => _addToCartWithAnimation(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedButton(
                      text: 'more_actions'.tr,
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isTapped = false.obs;

    return GestureDetector(
      onTapDown: (_) => isTapped.value = true,
      onTapUp: (_) {
        isTapped.value = false;
        onPressed();
      },
      onTapCancel: () => isTapped.value = false,
      child: Obx(
        () => AnimatedScale(
          scale: isTapped.value ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedImageToCart extends StatefulWidget {
  final String imageUrl;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onAnimationComplete;

  const AnimatedImageToCart({
    required this.imageUrl,
    required this.startPosition,
    required this.endPosition,
    required this.onAnimationComplete,
    super.key,
  });

  @override
  _AnimatedImageToCartState createState() => _AnimatedImageToCartState();
}

class _AnimatedImageToCartState extends State<AnimatedImageToCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _positionAnimation.value.dx,
      top: _positionAnimation.value.dy,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Opacity(
          opacity: _opacityAnimation.value,
          child: Image.network(
            widget.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}