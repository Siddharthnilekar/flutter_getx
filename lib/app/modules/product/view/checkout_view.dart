import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

class CheckoutView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('checkout'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'thank_you'.tr,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              '${'total'.tr}: \$${cartController.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimatedButton(
                text: 'place_order'.tr,
                onPressed: () {
                  cartController.cartService.clearCart();
                  Get.snackbar(
                    'order_completed'.tr,
                    'order_placed'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                  Get.offAllNamed('/product');
                },
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
  final VoidCallback onPressed;

  AnimatedButton({required this.text, required this.onPressed});

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
          duration: Duration(milliseconds: 200),
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