import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'cart'.tr,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18, // Aligned with CheckoutView
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: isDarkMode ? 0 : 2,
        shadowColor: isDarkMode ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      body: Obx(
        () => cartController.cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'empty_cart'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6), // Aligned with CheckoutView
                    Text(
                      'add_items_to_cart'.tr,
                      style: TextStyle(
                        fontSize: 14, // Aligned with CheckoutView
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6), // Aligned with CheckoutView
                    AnimatedButton(
                      text: 'shop_now'.tr,
                      onPressed: () => Get.toNamed('/product'),
                      icon: Icons.store,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 80.0), // Aligned with CheckoutView
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items
                        Text(
                          'your_cart'.tr,
                          style: TextStyle(
                            fontSize: 18, // Aligned with CheckoutView
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6), // Aligned with CheckoutView
                        ...cartController.cartItems.map((product) {
                          return Card(
                            elevation: 3, // Aligned with CheckoutView
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Aligned with CheckoutView
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(6.0), // Aligned with CheckoutView
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  product.image,
                                  width: 40, // Aligned with CheckoutView
                                  height: 40, // Aligned with CheckoutView
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 40,
                                  ),
                                ),
                              ),
                              title: Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 14, // Aligned with CheckoutView
                                ),
                              ),
                              subtitle: Text(
                                '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 12, // Aligned with CheckoutView
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    onPressed: () => cartController.removeFromCart(product),
                                  ),
                                  Obx(
                                    () => Text(
                                      '${cartController.getQuantity(product)}',
                                      style: TextStyle(
                                        fontSize: 14, // Aligned with CheckoutView
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    onPressed: () => cartController.addToCart(product),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 12), // Aligned with CheckoutView

                        // Total
                        Card(
                          elevation: 3, // Aligned with CheckoutView
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Aligned with CheckoutView
                          child: Padding(
                            padding: const EdgeInsets.all(12.0), // Aligned with CheckoutView
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total'.tr,
                                      style: TextStyle(
                                        fontSize: 14, // Aligned with CheckoutView (subtotal size)
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        '\$${cartController.totalAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16, // Aligned with CheckoutView (total size)
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: SafeArea(
                      child: Center(
                        child: AnimatedButton(
                          text: 'proceed_to_checkout'.tr,
                          onPressed: () => Get.toNamed('/checkout'),
                          icon: Icons.check_circle,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isDarkMode;
  final bool isLoading;

  const AnimatedButton({
    required this.text,
    this.onPressed,
    this.icon,
    required this.isDarkMode,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isTapped = false.obs;

    return GestureDetector(
      onTapDown: onPressed != null && !isLoading ? (_) => isTapped.value = true : null,
      onTapUp: onPressed != null && !isLoading
          ? (_) {
              isTapped.value = false;
              onPressed!();
            }
          : null,
      onTapCancel: onPressed != null && !isLoading ? () => isTapped.value = false : null,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceOut,
          transform: Matrix4.identity()..scale((isTapped.value && !isLoading) ? 0.95 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10), // Aligned with CheckoutView
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  blurRadius: 6, // Aligned with CheckoutView
                  offset: const Offset(0, 3), // Aligned with CheckoutView
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Aligned with CheckoutView
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Aligned with CheckoutView
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 18, // Aligned with CheckoutView
                    ),
                    const SizedBox(width: 6), // Aligned with CheckoutView
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14, // Aligned with CheckoutView
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}