// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

// class CartView extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();

//   CartView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'cart'.tr,
//           style: TextStyle(
//             color: isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//         backgroundColor: isDarkMode
//             ? Theme.of(context).colorScheme.primary
//             : Colors.white,
//         foregroundColor: isDarkMode ? Colors.white : Colors.black,
//         elevation: isDarkMode ? 0 : 2,
//         shadowColor: isDarkMode ? null : Colors.grey.withOpacity(0.3),
//       ),
//       body: Obx(
//         () => cartController.cartItems.isEmpty
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.shopping_cart_outlined,
//                       size: 100,
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'empty_cart'.tr,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'add_items_to_cart'.tr,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     AnimatedButton(
//                       text: 'shop_now'.tr,
//                       onPressed: () => Get.toNamed('/product'),
//                       icon: Icons.store,
//                       iconColor: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ],
//                 ),
//               )
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Cart Items
//                     Text(
//                       'your_cart'.tr,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...cartController.cartItems.map((product) {
//                       return Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(8.0),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               product.image,
//                               width: 50,
//                               height: 50,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => Icon(
//                                 Icons.image_not_supported,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 size: 50,
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             product.title,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           subtitle: Text(
//                             '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.remove_circle_outline,
//                                   color: isDarkMode ? Colors.white : Colors.black,
//                                 ),
//                                 onPressed: () => cartController.removeFromCart(product),
//                               ),
//                               Obx(
//                                 () => Text(
//                                   '${cartController.getQuantity(product)}',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Theme.of(context).colorScheme.onSurface,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.add_circle_outline,
//                                   color: isDarkMode ? Colors.white : Colors.black,
//                                 ),
//                                 onPressed: () => cartController.addToCart(product),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     const SizedBox(height: 16),

//                     // Total
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'total'.tr,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                             Obx(
//                               () => Text(
//                                 '\$${cartController.totalAmount.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Theme.of(context).colorScheme.onSurface,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Proceed to Checkout
//                     Center(
//                       child: AnimatedButton(
//                         text: 'proceed_to_checkout'.tr,
//                         onPressed: () => Get.toNamed('/checkout'),
//                         icon: Icons.check_circle,
//                         iconColor: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class AnimatedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final IconData? icon;
//   final Color? iconColor;

//   const AnimatedButton({
//     required this.text,
//     this.onPressed,
//     this.icon,
//     this.iconColor,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final RxBool isTapped = false.obs;

//     return GestureDetector(
//       onTapDown: onPressed != null ? (_) => isTapped.value = true : null,
//       onTapUp: onPressed != null
//           ? (_) {
//               isTapped.value = false;
//               onPressed!();
//             }
//           : null,
//       onTapCancel: onPressed != null ? () => isTapped.value = false : null,
//       child: Obx(
//         () => AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.bounceOut,
//           transform: Matrix4.identity()..scale(isTapped.value ? 0.95 : 1.0),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Theme.of(context).colorScheme.primary,
//                   Theme.of(context).colorScheme.primary.withOpacity(0.8),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (icon != null) ...[
//                     Icon(
//                       icon,
//                       color: iconColor ?? Colors.white,
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                   Text(
//                     text,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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
                    const SizedBox(height: 8),
                    Text(
                      'add_items_to_cart'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedButton(
                      text: 'shop_now'.tr,
                      onPressed: () => Get.toNamed('/product'),
                      icon: Icons.store,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart Items
                    Text(
                      'your_cart'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...cartController.cartItems.map((product) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.image_not_supported,
                                color: Theme.of(context).colorScheme.primary,
                                size: 50,
                              ),
                            ),
                          ),
                          title: Text(
                            product.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                                    fontSize: 16,
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
                    const SizedBox(height: 16),

                    // Total
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'total'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Obx(
                              () => Text(
                                '\$${cartController.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Proceed to Checkout
                    Center(
                      child: AnimatedButton(
                        text: 'proceed_to_checkout'.tr,
                        onPressed: () => Get.toNamed('/checkout'),
                        icon: Icons.check_circle,
                        isDarkMode: isDarkMode,
                      ),
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
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isDarkMode;

  const AnimatedButton({
    required this.text,
    this.onPressed,
    this.icon,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isTapped = false.obs;

    return GestureDetector(
      onTapDown: onPressed != null ? (_) => isTapped.value = true : null,
      onTapUp: onPressed != null
          ? (_) {
              isTapped.value = false;
              onPressed!();
            }
          : null,
      onTapCancel: onPressed != null ? () => isTapped.value = false : null,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceOut,
          transform: Matrix4.identity()..scale(isTapped.value ? 0.95 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
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