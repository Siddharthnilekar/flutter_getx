// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

// // class CheckoutView extends StatelessWidget {
// //   final CartController cartController = Get.find<CartController>();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('checkout'.tr),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               'thank_you'.tr,
// //               style: TextStyle(fontSize: 24),
// //             ),
// //             SizedBox(height: 10),
// //             Text(
// //               '${'total'.tr}: \$${cartController.totalAmount.toStringAsFixed(2)}',
// //               style: TextStyle(fontSize: 20),
// //             ),
// //             SizedBox(height: 20),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //               child: AnimatedButton(
// //                 text: 'place_order'.tr,
// //                 onPressed: () {
// //                   cartController.cartService.clearCart();
// //                   Get.snackbar(
// //                     'order_completed'.tr,
// //                     'order_placed'.tr,
// //                     snackPosition: SnackPosition.BOTTOM,
// //                     duration: Duration(seconds: 2),
// //                     backgroundColor: Colors.blue,
// //                     colorText: Colors.white,
// //                   );
// //                   Get.offAllNamed('/product');
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AnimatedButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback onPressed;

// //   AnimatedButton({required this.text, required this.onPressed});

// //   @override
// //   Widget build(BuildContext context) {
// //     final RxBool isTapped = false.obs;

// //     return GestureDetector(
// //       onTapDown: (_) => isTapped.value = true,
// //       onTapUp: (_) {
// //         isTapped.value = false;
// //         onPressed();
// //       },
// //       onTapCancel: () => isTapped.value = false,
// //       child: Obx(
// //         () => AnimatedScale(
// //           scale: isTapped.value ? 0.95 : 1.0,
// //           duration: Duration(milliseconds: 200),
// //           curve: Curves.easeInOut,
// //           child: ElevatedButton(
// //             onPressed: onPressed,
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
// //             ),
// //             child: Text(
// //               text,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

// // class CheckoutView extends StatelessWidget {
// //   final CartController cartController = Get.find<CartController>();
// //   final CheckoutController checkoutController = Get.put(CheckoutController());

// //   CheckoutView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('checkout'.tr),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Order Summary
// //             Text(
// //               'order_summary'.tr,
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               padding: const EdgeInsets.all(8.0),
// //               decoration: BoxDecoration(
// //                 border: Border.all(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Column(
// //                 children: [
// //                   // Only wrap the ListView in Obx for cartItems
// //                   Obx(
// //                     () => Column(
// //                       children: cartController.cartItems.isEmpty
// //                           ? [
// //                               Text(
// //                                 'empty_cart'.tr,
// //                                 style: TextStyle(
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                 ),
// //                               ),
// //                             ]
// //                           : cartController.cartItems.map((product) {
// //                               return ListTile(
// //                                 title: Text(
// //                                   product.title,
// //                                   style: TextStyle(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                   ),
// //                                 ),
// //                                 subtitle: Text(
// //                                   '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
// //                                   style: TextStyle(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                   ),
// //                                 ),
// //                               );
// //                             }).toList(),
// //                     ),
// //                   ),
// //                   const Divider(),
// //                   // Wrap total amount separately in Obx
// //                   Obx(
// //                     () => Text(
// //                       '${'total'.tr}: \$${cartController.totalAmount.toStringAsFixed(2)}',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Theme.of(context).colorScheme.onSurface,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // Shipping Address
// //             Text(
// //               'shipping_address'.tr,
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             TextField(
// //               onChanged: (value) => checkoutController.fullName.value = value,
// //               decoration: InputDecoration(
// //                 labelText: 'full_name'.tr,
// //                 labelStyle: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //                 border: OutlineInputBorder(),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //               ),
// //               style: TextStyle(
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             TextField(
// //               onChanged: (value) => checkoutController.streetAddress.value = value,
// //               decoration: InputDecoration(
// //                 labelText: 'street_address'.tr,
// //                 labelStyle: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //                 border: OutlineInputBorder(),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //               ),
// //               style: TextStyle(
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             TextField(
// //               onChanged: (value) => checkoutController.city.value = value,
// //               decoration: InputDecoration(
// //                 labelText: 'city'.tr,
// //                 labelStyle: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //                 border: OutlineInputBorder(),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //               ),
// //               style: TextStyle(
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             TextField(
// //               onChanged: (value) => checkoutController.postalCode.value = value,
// //               decoration: InputDecoration(
// //                 labelText: 'postal_code'.tr,
// //                 labelStyle: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //                 border: OutlineInputBorder(),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //               ),
// //               style: TextStyle(
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // Payment Method
// //             Text(
// //               'payment_method'.tr,
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Obx(
// //               () => Column(
// //                 children: checkoutController.paymentMethods.map((method) {
// //                   return RadioListTile<String>(
// //                     title: Text(
// //                       method.tr,
// //                       style: TextStyle(
// //                         color: Theme.of(context).colorScheme.onSurface,
// //                       ),
// //                     ),
// //                     value: method,
// //                     groupValue: checkoutController.selectedPaymentMethod.value,
// //                     onChanged: (value) {
// //                       if (value != null) {
// //                         checkoutController.selectedPaymentMethod.value = value;
// //                       }
// //                     },
// //                     activeColor: Theme.of(context).colorScheme.primary,
// //                   );
// //                 }).toList(),
// //               ),
// //             ),
// //             const SizedBox(height: 20),

// //             // Place Order Button
// //             Center(
// //               child: AnimatedButton(
// //                 text: 'place_order'.tr,
// //                 onPressed: checkoutController.placeOrder,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AnimatedButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback onPressed;

// //   const AnimatedButton({required this.text, required this.onPressed, super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final RxBool isTapped = false.obs;

// //     return GestureDetector(
// //       onTapDown: (_) => isTapped.value = true,
// //       onTapUp: (_) {
// //         isTapped.value = false;
// //         onPressed();
// //       },
// //       onTapCancel: () => isTapped.value = false,
// //       child: Obx(
// //         () => AnimatedScale(
// //           scale: isTapped.value ? 0.95 : 1.0,
// //           duration: const Duration(milliseconds: 200),
// //           curve: Curves.easeInOut,
// //           child: ElevatedButton(
// //             onPressed: onPressed,
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //             ),
// //             child: Text(
// //               text,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

// // class CheckoutView extends StatelessWidget {
// //   final CartController cartController = Get.find<CartController>();
// //   final CheckoutController checkoutController = Get.put(CheckoutController());

// //   CheckoutView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('checkout'.tr),
// //         backgroundColor: Theme.of(context).colorScheme.primary,
// //         foregroundColor: Theme.of(context).colorScheme.onPrimary,
// //       ),
// //       body: Column(
// //         children: [
// //           // Progress Indicator
// //           Container(
// //             padding: const EdgeInsets.symmetric(vertical: 16.0),
// //             color: Theme.of(context).colorScheme.surface,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 _buildProgressStep(context, 'Cart', Icons.shopping_cart, false),
// //                 _buildProgressStep(context, 'Checkout', Icons.payment, true),
// //                 _buildProgressStep(context, 'Confirmation', Icons.check_circle, false),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: SingleChildScrollView(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Order Summary Section
// //                   _buildSection(
// //                     context,
// //                     title: 'order_summary'.tr,
// //                     icon: Icons.list_alt,
// //                     isExpanded: checkoutController.isOrderSummaryExpanded,
// //                     child: Obx(
// //                       () => Column(
// //                         children: cartController.cartItems.isEmpty
// //                             ? [
// //                                 Text(
// //                                   'empty_cart'.tr,
// //                                   style: TextStyle(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                     fontSize: 16,
// //                                   ),
// //                                 ),
// //                               ]
// //                             : [
// //                                 ...cartController.cartItems.map((product) {
// //                                   return ListTile(
// //                                     leading: Icon(Icons.inventory, color: Theme.of(context).colorScheme.primary),
// //                                     title: Text(
// //                                       product.title,
// //                                       style: TextStyle(
// //                                         color: Theme.of(context).colorScheme.onSurface,
// //                                         fontWeight: FontWeight.bold,
// //                                       ),
// //                                     ),
// //                                     subtitle: Text(
// //                                       '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
// //                                       style: TextStyle(
// //                                         color: Theme.of(context).colorScheme.onSurface,
// //                                       ),
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                                 const Divider(),
// //                                 Obx(
// //                                   () => Text(
// //                                     '${'total'.tr}: \$${cartController.totalAmount.toStringAsFixed(2)}',
// //                                     style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Theme.of(context).colorScheme.onSurface,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Shipping Address Section
// //                   _buildSection(
// //                     context,
// //                     title: 'shipping_address'.tr,
// //                     icon: Icons.location_on,
// //                     isExpanded: checkoutController.isAddressExpanded,
// //                     child: Column(
// //                       children: [
// //                         // Saved Addresses Dropdown
// //                         Obx(
// //                           () => DropdownButton<Address>(
// //                             isExpanded: true,
// //                             hint: Text(
// //                               'select_saved_address'.tr,
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             value: checkoutController.selectedAddress.value,
// //                             items: checkoutController.savedAddresses.map((address) {
// //                               return DropdownMenuItem<Address>(
// //                                 value: address,
// //                                 child: Text(
// //                                   '${address.fullName}, ${address.streetAddress}, ${address.city}',
// //                                   style: TextStyle(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                   ),
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             onChanged: checkoutController.selectAddress,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         // Address Input Fields
// //                         _buildTextField(
// //                           context,
// //                           label: 'full_name'.tr,
// //                           icon: Icons.person,
// //                           onChanged: (value) => checkoutController.fullName.value = value,
// //                         ),
// //                         const SizedBox(height: 8),
// //                         _buildTextField(
// //                           context,
// //                           label: 'street_address'.tr,
// //                           icon: Icons.home,
// //                           onChanged: (value) => checkoutController.streetAddress.value = value,
// //                         ),
// //                         const SizedBox(height: 8),
// //                         _buildTextField(
// //                           context,
// //                           label: 'city'.tr,
// //                           icon: Icons.location_city,
// //                           onChanged: (value) => checkoutController.city.value = value,
// //                         ),
// //                         const SizedBox(height: 8),
// //                         _buildTextField(
// //                           context,
// //                           label: 'postal_code'.tr,
// //                           icon: Icons.local_post_office,
// //                           onChanged: (value) => checkoutController.postalCode.value = value,
// //                         ),
// //                         const SizedBox(height: 8),
// //                         AnimatedButton(
// //                           text: 'save_address'.tr,
// //                           onPressed: checkoutController.addNewAddress,
// //                           icon: Icons.save,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Payment Method Section
// //                   _buildSection(
// //                     context,
// //                     title: 'payment_method'.tr,
// //                     icon: Icons.payment,
// //                     isExpanded: checkoutController.isPaymentExpanded,
// //                     child: Obx(
// //                       () => Column(
// //                         children: [
// //                           ...checkoutController.paymentMethods.map((method) {
// //                             return RadioListTile<String>(
// //                               title: Text(
// //                                 method.tr,
// //                                 style: TextStyle(
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                 ),
// //                               ),
// //                               value: method,
// //                               groupValue: checkoutController.selectedPaymentMethod.value,
// //                               onChanged: (value) {
// //                                 if (value != null) {
// //                                   checkoutController.selectedPaymentMethod.value = value;
// //                                 }
// //                               },
// //                               activeColor: Theme.of(context).colorScheme.primary,
// //                               secondary: Icon(
// //                                 method == 'Credit Card'
// //                                     ? Icons.credit_card
// //                                     : method == 'PayPal'
// //                                         ? Icons.account_balance_wallet
// //                                         : Icons.local_shipping,
// //                                 color: Theme.of(context).colorScheme.primary,
// //                               ),
// //                             );
// //                           }).toList(),
// //                           if (checkoutController.selectedPaymentMethod.value == 'Credit Card') ...[
// //                             const SizedBox(height: 8),
// //                             _buildTextField(
// //                               context,
// //                               label: 'card_number'.tr,
// //                               icon: Icons.credit_card,
// //                               onChanged: (value) => checkoutController.cardNumber.value = value,
// //                               keyboardType: TextInputType.number,
// //                             ),
// //                             const SizedBox(height: 8),
// //                             _buildTextField(
// //                               context,
// //                               label: 'expiry_date'.tr,
// //                               icon: Icons.calendar_today,
// //                               onChanged: (value) => checkoutController.expiryDate.value = value,
// //                               keyboardType: TextInputType.datetime,
// //                             ),
// //                             const SizedBox(height: 8),
// //                             _buildTextField(
// //                               context,
// //                               label: 'cvv'.tr,
// //                               icon: Icons.lock,
// //                               onChanged: (value) => checkoutController.cvv.value = value,
// //                               keyboardType: TextInputType.number,
// //                               obscureText: true,
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Order Notes
// //                   _buildSection(
// //                     context,
// //                     title: 'order_notes'.tr,
// //                     icon: Icons.note,
// //                     isExpanded: RxBool(true),
// //                     child: _buildTextField(
// //                       context,
// //                       label: 'notes'.tr,
// //                       icon: Icons.edit,
// //                       onChanged: (value) => checkoutController.orderNotes.value = value,
// //                       maxLines: 3,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),

// //                   // Place Order Button
// //                   Center(
// //                     child: Obx(
// //                       () => AnimatedButton(
// //                         text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
// //                         onPressed: checkoutController.isPlacingOrder.value ? null : checkoutController.placeOrder,
// //                         icon: checkoutController.isPlacingOrder.value ? Icons.hourglass_empty : Icons.check_circle,
// //                         isLoading: checkoutController.isPlacingOrder.value,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildProgressStep(BuildContext context, String title, IconData icon, bool isActive) {
// //     return Column(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(8.0),
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
// //             border: Border.all(color: Theme.of(context).colorScheme.primary),
// //           ),
// //           child: Icon(
// //             icon,
// //             color: isActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
// //           ),
// //         ),
// //         const SizedBox(height: 4),
// //         Text(
// //           title.tr,
// //           style: TextStyle(
// //             color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
// //             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildSection(
// //     BuildContext context, {
// //     required String title,
// //     required IconData icon,
// //     required RxBool isExpanded,
// //     required Widget child,
// //   }) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: ExpansionTile(
// //         leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
// //         title: Text(
// //           title,
// //           style: TextStyle(
// //             fontSize: 18,
// //             fontWeight: FontWeight.bold,
// //             color: Theme.of(context).colorScheme.onSurface,
// //           ),
// //         ),
// //         onExpansionChanged: (expanded) => isExpanded.value = expanded,
// //         initiallyExpanded: isExpanded.value,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: AnimatedSlide(
// //               offset: isExpanded.value ? Offset.zero : const Offset(0, -0.1),
// //               duration: const Duration(milliseconds: 300),
// //               curve: Curves.easeInOut,
// //               child: AnimatedOpacity(
// //                 opacity: isExpanded.value ? 1.0 : 0.0,
// //                 duration: const Duration(milliseconds: 300),
// //                 child: child,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTextField(
// //     BuildContext context, {
// //     required String label,
// //     required IconData icon,
// //     required Function(String) onChanged,
// //     TextInputType? keyboardType,
// //     bool obscureText = false,
// //     int maxLines = 1,
// //   }) {
// //     return TextField(
// //       onChanged: onChanged,
// //       keyboardType: keyboardType,
// //       obscureText: obscureText,
// //       maxLines: maxLines,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: TextStyle(
// //           color: Theme.of(context).colorScheme.onSurface,
// //         ),
// //         prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderSide: BorderSide(
// //             color: Theme.of(context).colorScheme.onSurface,
// //           ),
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderSide: BorderSide(
// //             color: Theme.of(context).colorScheme.primary,
// //             width: 2,
// //           ),
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         filled: true,
// //         fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
// //       ),
// //       style: TextStyle(
// //         color: Theme.of(context).colorScheme.onSurface,
// //       ),
// //     );
// //   }
// // }

// // class AnimatedButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback? onPressed;
// //   final IconData? icon;
// //   final bool isLoading;

// //   const AnimatedButton({
// //     required this.text,
// //     this.onPressed,
// //     this.icon,
// //     this.isLoading = false,
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final RxBool isTapped = false.obs;

// //     return GestureDetector(
// //       onTapDown: onPressed != null ? (_) => isTapped.value = true : null,
// //       onTapUp: onPressed != null
// //           ? (_) {
// //               isTapped.value = false;
// //               onPressed!();
// //             }
// //           : null,
// //       onTapCancel: onPressed != null ? () => isTapped.value = false : null,
// //       child: Obx(
// //         () => AnimatedScale(
// //           scale: isTapped.value && !isLoading ? 0.95 : 1.0,
// //           duration: const Duration(milliseconds: 200),
// //           curve: Curves.bounceOut,
// //           child: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Theme.of(context).colorScheme.primary,
// //                   Theme.of(context).colorScheme.primary.withOpacity(0.8),
// //                 ],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //               borderRadius: BorderRadius.circular(12),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: ElevatedButton(
// //               onPressed: onPressed,
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
// //                 backgroundColor: Colors.transparent,
// //                 shadowColor: Colors.transparent,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   if (isLoading) ...[
// //                     const SizedBox(
// //                       width: 20,
// //                       height: 20,
// //                       child: CircularProgressIndicator(
// //                         strokeWidth: 2,
// //                         valueColor: AlwaysStoppedAnimation(Colors.white),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                   ] else if (icon != null) ...[
// //                     Icon(icon, color: Colors.white),
// //                     const SizedBox(width: 8),
// //                   ],
// //                   Text(
// //                     text,
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
// // import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';
// // import 'package:getx_chapter_1/app/modules/product/view/address_selection_view.dart';

// // class CheckoutView extends StatelessWidget {
// //   final CartController cartController = Get.find<CartController>();
// //   final CheckoutController checkoutController = Get.find<CheckoutController>();

// //   CheckoutView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('checkout'.tr),
// //         backgroundColor: Theme.of(context).colorScheme.primary,
// //         foregroundColor: Theme.of(context).colorScheme.onPrimary,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Delivery Address
// //             Card(
// //               elevation: 4,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
// //                         const SizedBox(width: 8),
// //                         Text(
// //                           'delivery_address'.tr,
// //                           style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                             color: Theme.of(context).colorScheme.onSurface,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Obx(
// //                       () => checkoutController.selectedAddress.value == null
// //                           ? Text(
// //                               'no_address_selected'.tr,
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             )
// //                           : Text(
// //                               '${checkoutController.selectedAddress.value!.fullName}\n${checkoutController.selectedAddress.value!.streetAddress}, ${checkoutController.selectedAddress.value!.city}, ${checkoutController.selectedAddress.value!.postalCode}, ${checkoutController.selectedAddress.value!.country}',
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                                 fontSize: 16,
// //                               ),
// //                             ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Align(
// //                       alignment: Alignment.centerRight,
// //                       child: TextButton.icon(
// //                         icon: Icon(Icons.edit_location, color: Theme.of(context).colorScheme.primary),
// //                         label: Text(
// //                           'change_delivery_address'.tr,
// //                           style: TextStyle(
// //                             color: Theme.of(context).colorScheme.primary,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         onPressed: () => Get.to(() => AddressSelectionView()),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // Order Summary
// //             Card(
// //               elevation: 4,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               child: ExpansionTile(
// //                 leading: Icon(Icons.list_alt, color: Theme.of(context).colorScheme.primary),
// //                 title: Text(
// //                   'order_summary'.tr,
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(16.0),
// //                     child: Obx(
// //                       () => Column(
// //                         children: cartController.cartItems.isEmpty
// //                             ? [
// //                                 Text(
// //                                   'empty_cart'.tr,
// //                                   style: TextStyle(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                     fontSize: 16,
// //                                   ),
// //                                 ),
// //                               ]
// //                             : [
// //                                 ...cartController.cartItems.map((product) {
// //                                   return ListTile(
// //                                     leading: Icon(Icons.inventory, color: Theme.of(context).colorScheme.primary),
// //                                     title: Text(
// //                                       product.title,
// //                                       style: TextStyle(
// //                                         color: Theme.of(context).colorScheme.onSurface,
// //                                         fontWeight: FontWeight.bold,
// //                                       ),
// //                                     ),
// //                                     subtitle: Text(
// //                                       '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
// //                                       style: TextStyle(
// //                                         color: Theme.of(context).colorScheme.onSurface,
// //                                       ),
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                                 const Divider(),
// //                                 Text(
// //                                   '${'subtotal'.tr}: \$${cartController.totalAmount.toStringAsFixed(2)}',
// //                                   style: TextStyle(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                     fontSize: 16,
// //                                   ),
// //                                 ),
// //                                 Obx(
// //                                   () => checkoutController.discount.value > 0
// //                                       ? Text(
// //                                           '${'discount'.tr}: -${(checkoutController.discount.value * 100).toStringAsFixed(0)}%',
// //                                           style: TextStyle(
// //                                             color: Colors.green,
// //                                             fontSize: 16,
// //                                           ),
// //                                         )
// //                                       : const SizedBox.shrink(),
// //                                 ),
// //                                 Obx(
// //                                   () => Text(
// //                                     '${'total'.tr}: \$${checkoutController.discountedTotal.toStringAsFixed(2)}',
// //                                     style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Theme.of(context).colorScheme.onSurface,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // Coupon Code
// //             Card(
// //               elevation: 4,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: TextField(
// //                         onChanged: (value) => checkoutController.couponCode.value = value,
// //                         decoration: InputDecoration(
// //                           labelText: 'coupon_code'.tr,
// //                           labelStyle: TextStyle(
// //                             color: Theme.of(context).colorScheme.onSurface,
// //                           ),
// //                           prefixIcon: Icon(Icons.local_offer, color: Theme.of(context).colorScheme.primary),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           enabledBorder: OutlineInputBorder(
// //                             borderSide: BorderSide(
// //                               color: Theme.of(context).colorScheme.onSurface,
// //                             ),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           focusedBorder: OutlineInputBorder(
// //                             borderSide: BorderSide(
// //                               color: Theme.of(context).colorScheme.primary,
// //                               width: 2,
// //                             ),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           filled: true,
// //                           fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
// //                         ),
// //                         style: TextStyle(
// //                           color: Theme.of(context).colorScheme.onSurface,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     AnimatedButton(
// //                       text: 'apply'.tr,
// //                       onPressed: checkoutController.applyCoupon,
// //                       icon: Icons.check,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // Payment Method
// //             Card(
// //               elevation: 4,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               child: ExpansionTile(
// //                 leading: Icon(Icons.payment, color: Theme.of(context).colorScheme.primary),
// //                 title: Text(
// //                   'payment_method'.tr,
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(16.0),
// //                     child: Obx(
// //                       () => Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           // Recommended GPay
// //                           RadioListTile<String>(
// //                             title: Text(
// //                               'GPay (Recommended)',
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             subtitle: Text(
// //                               'pay_with_gpay'.tr,
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             value: 'GPay',
// //                             groupValue: checkoutController.selectedPaymentMethod.value,
// //                             onChanged: (value) {
// //                               if (value != null) {
// //                                 checkoutController.selectedPaymentMethod.value = value;
// //                               }
// //                             },
// //                             activeColor: Theme.of(context).colorScheme.primary,
// //                             secondary: Icon(Icons.account_balance_wallet, color: Theme.of(context).colorScheme.primary),
// //                           ),
// //                           // Other UPI
// //                           RadioListTile<String>(
// //                             title: Text(
// //                               'Other UPI',
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             subtitle: Text(
// //                               'pay_with_upi'.tr,
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             value: 'Other UPI',
// //                             groupValue: checkoutController.selectedPaymentMethod.value,
// //                             onChanged: (value) {
// //                               if (value != null) {
// //                                 checkoutController.selectedPaymentMethod.value = value;
// //                               }
// //                             },
// //                             activeColor: Theme.of(context).colorScheme.primary,
// //                             secondary: Icon(Icons.payment, color: Theme.of(context).colorScheme.primary),
// //                           ),
// //                           // Card Payment
// //                           RadioListTile<String>(
// //                             title: Text(
// //                               'Card Payment',
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             subtitle: Text(
// //                               'pay_with_card'.tr,
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             value: 'Card Payment',
// //                             groupValue: checkoutController.selectedPaymentMethod.value,
// //                             onChanged: (value) {
// //                               if (value != null) {
// //                                 checkoutController.selectedPaymentMethod.value = value;
// //                               }
// //                             },
// //                             activeColor: Theme.of(context).colorScheme.primary,
// //                             secondary: Icon(Icons.credit_card, color: Theme.of(context).colorScheme.primary),
// //                           ),
// //                           // Saved Cards
// //                           if (checkoutController.selectedPaymentMethod.value == 'Card Payment' &&
// //                               checkoutController.savedCards.isNotEmpty) ...[
// //                             const SizedBox(height: 8),
// //                             DropdownButton<CardDetails>(
// //                               isExpanded: true,
// //                               hint: Text(
// //                                 'select_saved_card'.tr,
// //                                 style: TextStyle(
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                 ),
// //                               ),
// //                               value: checkoutController.selectedCard.value,
// //                               items: checkoutController.savedCards.map((card) {
// //                                 return DropdownMenuItem<CardDetails>(
// //                                   value: card,
// //                                   child: Text(
// //                                     '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
// //                                     style: TextStyle(
// //                                       color: Theme.of(context).colorScheme.onSurface,
// //                                     ),
// //                                   ),
// //                                 );
// //                               }).toList(),
// //                               onChanged: checkoutController.selectCard,
// //                             ),
// //                             const SizedBox(height: 8),
// //                           ],
// //                           // Card Details
// //                           if (checkoutController.selectedPaymentMethod.value == 'Card Payment') ...[
// //                             const SizedBox(height: 8),
// //                             TextField(
// //                               onChanged: (value) => checkoutController.cardNumber.value = value,
// //                               decoration: InputDecoration(
// //                                 labelText: 'card_number'.tr,
// //                                 labelStyle: TextStyle(
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                 ),
// //                                 prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).colorScheme.primary),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 enabledBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 focusedBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                     color: Theme.of(context).colorScheme.primary,
// //                                     width: 2,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 filled: true,
// //                                 fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
// //                               ),
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                             ),
// //                             const SizedBox(height: 8),
// //                             TextField(
// //                               onChanged: (value) => checkoutController.expiryDate.value = value,
// //                               decoration: InputDecoration(
// //                                 labelText: 'expiry_date'.tr,
// //                                 labelStyle: TextStyle(
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                 ),
// //                                 prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 enabledBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 focusedBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                     color: Theme.of(context).colorScheme.primary,
// //                                     width: 2,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 filled: true,
// //                                 fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
// //                               ),
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                               keyboardType: TextInputType.datetime,
// //                             ),
// //                             const SizedBox(height: 8),
// //                             TextField(
// //                               onChanged: (value) => checkoutController.cvv.value = value,
// //                               decoration: InputDecoration(
// //                                 labelText: 'cvv'.tr,
// //                                 labelStyle: TextStyle(
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                 ),
// //                                 prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 enabledBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                     color: Theme.of(context).colorScheme.onSurface,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 focusedBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                     color: Theme.of(context).colorScheme.primary,
// //                                     width: 2,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 filled: true,
// //                                 fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
// //                               ),
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               obscureText: true,
// //                             ),
// //                           ],
// //                           // Cash on Delivery
// //                           RadioListTile<String>(
// //                             title: Text(
// //                               'Cash on Delivery',
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             subtitle: Text(
// //                               'pay_on_delivery'.tr,
// //                               style: TextStyle(
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             value: 'Cash on Delivery',
// //                             groupValue: checkoutController.selectedPaymentMethod.value,
// //                             onChanged: (value) {
// //                               if (value != null) {
// //                                 checkoutController.selectedPaymentMethod.value = value;
// //                               }
// //                             },
// //                             activeColor: Theme.of(context).colorScheme.primary,
// //                             secondary: Icon(Icons.local_shipping, color: Theme.of(context).colorScheme.primary),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 20),

// //             // Place Order Button
// //             Center(
// //               child: Obx(
// //                 () => AnimatedButton(
// //                   text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
// //                   onPressed: checkoutController.isPlacingOrder.value ? null : checkoutController.placeOrder,
// //                   icon: checkoutController.isPlacingOrder.value ? Icons.hourglass_empty : Icons.check_circle,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AnimatedButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback? onPressed;
// //   final IconData? icon;

// //   const AnimatedButton({
// //     required this.text,
// //     this.onPressed,
// //     this.icon,
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final RxBool isTapped = false.obs;

// //     return GestureDetector(
// //       onTapDown: onPressed != null ? (_) => isTapped.value = true : null,
// //       onTapUp: onPressed != null
// //           ? (_) {
// //               isTapped.value = false;
// //               onPressed!();
// //             }
// //           : null,
// //       onTapCancel: onPressed != null ? () => isTapped.value = false : null,
// //       child: Obx(
// //         () => AnimatedScale(
// //           scale: isTapped.value ? 0.95 : 1.0,
// //           duration: const Duration(milliseconds: 200),
// //           curve: Curves.bounceOut,
// //           child: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Theme.of(context).colorScheme.primary,
// //                   Theme.of(context).colorScheme.primary.withOpacity(0.8),
// //                 ],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //               borderRadius: BorderRadius.circular(12),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: ElevatedButton(
// //               onPressed: onPressed,
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
// //                 backgroundColor: Colors.transparent,
// //                 shadowColor: Colors.transparent,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   if (icon != null) ...[
// //                     Icon(icon, color: Colors.white),
// //                     const SizedBox(width: 8),
// //                   ],
// //                   Text(
// //                     text,
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';
// import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

// class CheckoutView extends StatelessWidget {
//   final CheckoutController checkoutController = Get.find<CheckoutController>();
//   final CartController cartController = Get.find<CartController>();

//   CheckoutView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('checkout'.tr),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(
//           () => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Delivery Address
//               Text(
//                 'delivery_address'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (checkoutController.selectedAddress.value == null)
//                         Text(
//                           'no_address_selected'.tr,
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         )
//                       else
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               checkoutController.selectedAddress.value!.fullName,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                             Text(
//                               '${checkoutController.selectedAddress.value!.streetAddress}, '
//                               '${checkoutController.selectedAddress.value!.city}, '
//                               '${checkoutController.selectedAddress.value!.postalCode}, '
//                               '${checkoutController.selectedAddress.value!.country}',
//                               style: TextStyle(
//                                 color: Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(height: 8),
//                       AnimatedButton(
//                         text: 'change_delivery_address'.tr,
//                         onPressed: () => Get.toNamed('/address-selection'),
//                         icon: Icons.edit_location,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Order Summary
//               Text(
//                 'order_summary'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               if (cartController.cartItems.isEmpty)
//                 Text(
//                   'cart_is_empty'.tr,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 )
//               else
//                 ...cartController.cartItems.map((product) {
//                   return Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(8.0),
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           product.image,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) => Icon(
//                             Icons.image_not_supported,
//                             color: Theme.of(context).colorScheme.primary,
//                             size: 50,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         product.title,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${'price'.tr}: \$${product.price.toStringAsFixed(2)} x ${cartController.getQuantity(product)}',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               const SizedBox(height: 16),

//               // Coupon Code
//               Text(
//                 'coupon_code'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) => checkoutController.couponCode.value = value,
//                       decoration: InputDecoration(
//                         labelText: 'coupon_code'.tr,
//                         labelStyle: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                         prefixIcon: Icon(Icons.discount, color: Theme.of(context).colorScheme.primary),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                       ),
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   AnimatedButton(
//                     text: 'apply'.tr,
//                     onPressed: () => checkoutController.applyCoupon(),
//                     icon: Icons.check,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Order Totals
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'subtotal'.tr,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           Text(
//                             '\$${cartController.totalAmount.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'discount'.tr,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           Text(
//                             checkoutController.discount.value > 0
//                                 ? '-\$${((cartController.totalAmount * checkoutController.discount.value).toStringAsFixed(2))}'
//                                 : '\$0.00',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'total'.tr,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           Text(
//                             '\$${checkoutController.discountedTotal.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Payment Method
//               Text(
//                 'payment_method'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               ...checkoutController.paymentMethods.map((method) {
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   child: RadioListTile<String>(
//                     title: Text(
//                       method.tr,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     subtitle: Text(
//                       'pay_with_${method.toLowerCase().replaceAll(' ', '_')}'.tr,
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     value: method,
//                     groupValue: checkoutController.selectedPaymentMethod.value,
//                     onChanged: (value) => checkoutController.selectedPaymentMethod.value = value!,
//                     activeColor: Theme.of(context).colorScheme.primary,
//                   ),
//                 );
//               }).toList(),
//               const SizedBox(height: 16),

//               // Credit Card Details
//               if (checkoutController.selectedPaymentMethod.value == 'Credit Card') ...[
//                 Text(
//                   'select_saved_card'.tr,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 if (checkoutController.savedCards.isEmpty)
//                   Text(
//                     'no_cards_saved'.tr,
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   )
//                 else
//                   ...checkoutController.savedCards.map((card) {
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: RadioListTile<CardDetails>(
//                         title: Text(
//                           '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Expires: ${card.expiryDate}',
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         value: card,
//                         groupValue: checkoutController.selectedCard.value,
//                         onChanged: (value) => checkoutController.selectCard(value),
//                         activeColor: Theme.of(context).colorScheme.primary,
//                       ),
//                     );
//                   }).toList(),
//                 const SizedBox(height: 16),
//                 Text(
//                   'card_details'.tr,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   onChanged: (value) => checkoutController.cardNumber.value = value,
//                   decoration: InputDecoration(
//                     labelText: 'card_number'.tr,
//                     labelStyle: TextStyle(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).colorScheme.primary),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Theme.of(context).colorScheme.primary,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     filled: true,
//                     fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                   ),
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) => checkoutController.expiryDate.value = value,
//                         decoration: InputDecoration(
//                           labelText: 'expiry_date'.tr,
//                           labelStyle: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                           prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Theme.of(context).colorScheme.primary,
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           filled: true,
//                           fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                         ),
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                         keyboardType: TextInputType.datetime,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) => checkoutController.cvv.value = value,
//                         decoration: InputDecoration(
//                           labelText: 'cvv'.tr,
//                           labelStyle: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                           prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Theme.of(context).colorScheme.primary,
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           filled: true,
//                           fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                         ),
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                         keyboardType: TextInputType.number,
//                         obscureText: true,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               // Place Order
//               Center(
//                 child: AnimatedButton(
//                   text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
//                   onPressed: checkoutController.isPlacingOrder.value ? null : () => checkoutController.placeOrder(),
//                   icon: Icons.check_circle,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AnimatedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final IconData? icon;

//   const AnimatedButton({
//     required this.text,
//     this.onPressed,
//     this.icon,
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
//                     Icon(icon, color: Colors.white),
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
import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final CartController cartController = Get.find<CartController>();

  CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'checkout'.tr,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: isDarkMode ? 0 : 2,
        shadowColor: isDarkMode ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Text(
                'delivery_address'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (checkoutController.selectedAddress.value == null)
                        Text(
                          'no_address_selected'.tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              checkoutController.selectedAddress.value!.fullName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${checkoutController.selectedAddress.value!.streetAddress}, '
                              '${checkoutController.selectedAddress.value!.city}, '
                              '${checkoutController.selectedAddress.value!.postalCode}, '
                              '${checkoutController.selectedAddress.value!.country}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      AnimatedButton(
                        text: 'change_delivery_address'.tr,
                        onPressed: () => Get.toNamed('/address-selection'),
                        icon: Icons.edit_location,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Order Summary
              Text(
                'order_summary'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              if (cartController.cartItems.isEmpty)
                Text(
                  'cart_is_empty'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              else
                ...cartController.cartItems.map((product) {
                  return Card(
                    elevation: 4,
                    color: Theme.of(context).colorScheme.surface,
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
                    ),
                  );
                }).toList(),
              const SizedBox(height: 16),

              // Coupon Code
              Text(
                'coupon_code'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => checkoutController.couponCode.value = value,
                      decoration: InputDecoration(
                        labelText: 'coupon_code'.tr,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        prefixIcon: Icon(Icons.discount, color: Theme.of(context).colorScheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedButton(
                    text: 'apply'.tr,
                    onPressed: () => checkoutController.applyCoupon(),
                    icon: Icons.check,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Order Totals
              Card(
                elevation: 4,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'subtotal'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '\$${cartController.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'discount'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            checkoutController.discount.value > 0
                                ? '-\$${((cartController.totalAmount * checkoutController.discount.value).toStringAsFixed(2))}'
                                : '\$0.00',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
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
                          Text(
                            '\$${checkoutController.discountedTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method
              Text(
                'payment_method'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              ...checkoutController.paymentMethods.map((method) {
                return Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: RadioListTile<String>(
                    title: Text(
                      method.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'pay_with_${method.toLowerCase().replaceAll(' ', '_')}'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    value: method,
                    groupValue: checkoutController.selectedPaymentMethod.value,
                    onChanged: (value) => checkoutController.selectedPaymentMethod.value = value!,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Credit Card Details
              if (checkoutController.selectedPaymentMethod.value == 'Credit Card') ...[
                Text(
                  'select_saved_card'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                if (checkoutController.savedCards.isEmpty)
                  Text(
                    'no_cards_saved'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                else
                  ...checkoutController.savedCards.map((card) {
                    return Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: RadioListTile<CardDetails>(
                        title: Text(
                          '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          'Expires: ${card.expiryDate}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        value: card,
                        groupValue: checkoutController.selectedCard.value,
                        onChanged: (value) => checkoutController.selectCard(value),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 16),
                Text(
                  'card_details'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) => checkoutController.cardNumber.value = value,
                  decoration: InputDecoration(
                    labelText: 'card_number'.tr,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => checkoutController.expiryDate.value = value,
                        decoration: InputDecoration(
                          labelText: 'expiry_date'.tr,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => checkoutController.cvv.value = value,
                        decoration: InputDecoration(
                          labelText: 'cvv'.tr,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Place Order
              Center(
                child: AnimatedButton(
                  text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
                  onPressed: checkoutController.isPlacingOrder.value ? null : () => checkoutController.placeOrder(),
                  icon: checkoutController.isPlacingOrder.value ? Icons.hourglass_empty : Icons.check_circle,
                  isDarkMode: isDarkMode,
                  isLoading: checkoutController.isPlacingOrder.value,
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
                  if (isLoading) ...[
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
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