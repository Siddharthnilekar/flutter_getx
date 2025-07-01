import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('empty_cart'.tr));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  final quantity = cartController.getQuantity(product);
                  return ListTile(
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                    title: Text(product.title),
                    subtitle: Text('${'price'.tr}: \$${product.price.toStringAsFixed(2)} x $quantity'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () => cartController.removeFromCart(product),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '${'total'.tr}: \$${cartController.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimatedButton(
                text: 'proceed_to_checkout'.tr,
                onPressed: () => Get.toNamed('/checkout'),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AnimatedButton({required this.text, required this.onPressed, super.key});

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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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