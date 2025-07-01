// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

// class AddressSelectionView extends StatelessWidget {
//   final CheckoutController checkoutController = Get.find<CheckoutController>();
//   final RxBool isEditing = false.obs;
//   final RxInt editingIndex = (-1).obs;

//   AddressSelectionView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('select_delivery_address'.tr),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(
//           () => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Saved Addresses
//               Text(
//                 'saved_addresses'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               if (checkoutController.savedAddresses.isEmpty)
//                 Text(
//                   'no_addresses'.tr,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 )
//               else
//                 ...checkoutController.savedAddresses.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final address = entry.value;
//                   return Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: RadioListTile<Address>(
//                       title: Text(
//                         address.fullName,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${address.streetAddress}, ${address.city}, ${address.postalCode}, ${address.country}',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       value: address,
//                       groupValue: checkoutController.selectedAddress.value,
//                       onChanged: (value) => checkoutController.selectAddress(value),
//                       secondary: IconButton(
//                         icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
//                         onPressed: () {
//                           isEditing.value = true;
//                           editingIndex.value = index;
//                           checkoutController.selectAddress(address);
//                         },
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               const SizedBox(height: 16),

//               // Add/Edit Address Form
//               Text(
//                 isEditing.value ? 'edit_address'.tr : 'add_new_address'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.fullName.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'full_name'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.streetAddress.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'street_address'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.city.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'city'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.postalCode.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'postal_code'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.local_post_office, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.country.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'country'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.flag, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               AnimatedButton(
//                 text: isEditing.value ? 'update_address'.tr : 'save_address'.tr,
//                 onPressed: () {
//                   if (isEditing.value) {
//                     checkoutController.updateAddress(editingIndex.value);
//                   } else {
//                     checkoutController.addNewAddress();
//                   }
//                 },
//                 icon: Icons.save,
//               ),
//               const SizedBox(height: 16),

//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: AnimatedButton(
//                       text: 'deliver_to_address'.tr,
//                       onPressed: checkoutController.selectedAddress.value != null
//                           ? () => Get.back()
//                           : null,
//                       icon: Icons.check_circle,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: AnimatedButton(
//                       text: 'back_to_cart'.tr,
//                       onPressed: () => Get.toNamed('/cart'),
//                       icon: Icons.arrow_back,
//                     ),
//                   ),
//                 ],
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



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

// class AddressSelectionView extends StatelessWidget {
//   final CheckoutController checkoutController = Get.find<CheckoutController>();
//   final RxBool isEditing = false.obs;
//   final RxInt editingIndex = (-1).obs;

//   AddressSelectionView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'select_delivery_address'.tr,
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         foregroundColor: Theme.of(context).colorScheme.onSurface,
//         elevation: isDarkMode ? 0 : 2,
//         shadowColor: isDarkMode ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(
//           () => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Saved Addresses
//               Text(
//                 'saved_addresses'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               if (checkoutController.savedAddresses.isEmpty)
//                 Text(
//                   'no_addresses'.tr,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 )
//               else
//                 ...checkoutController.savedAddresses.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final address = entry.value;
//                   return Card(
//                     elevation: 4,
//                     color: Theme.of(context).colorScheme.surface,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: RadioListTile<Address>(
//                       title: Text(
//                         address.fullName,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${address.streetAddress}, ${address.city}, ${address.postalCode}, ${address.country}',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       value: address,
//                       groupValue: checkoutController.selectedAddress.value,
//                       onChanged: (value) => checkoutController.selectAddress(value),
//                       secondary: IconButton(
//                         icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
//                         onPressed: () {
//                           isEditing.value = true;
//                           editingIndex.value = index;
//                           checkoutController.selectAddress(address);
//                         },
//                       ),
//                       activeColor: Theme.of(context).colorScheme.primary,
//                     ),
//                   );
//                 }).toList(),
//               const SizedBox(height: 16),

//               // Add/Edit Address Form
//               Text(
//                 isEditing.value ? 'edit_address'.tr : 'add_new_address'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.fullName.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'full_name'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.streetAddress.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'street_address'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.city.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'city'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.postalCode.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'postal_code'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.local_post_office, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 onChanged: (value) => checkoutController.country.value = value,
//                 decoration: InputDecoration(
//                   labelText: 'country'.tr,
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   prefixIcon: Icon(Icons.flag, color: Theme.of(context).colorScheme.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
//                 ),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Center(
//                 child: AnimatedButton(
//                   text: isEditing.value ? 'update_address'.tr : 'save_address'.tr,
//                   onPressed: () {
//                     if (isEditing.value) {
//                       checkoutController.updateAddress(editingIndex.value);
//                     } else {
//                       checkoutController.addNewAddress();
//                     }
//                   },
//                   icon: Icons.save,
//                   isDarkMode: isDarkMode,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Buttons
//               Wrap(
//                 spacing: 16,
//                 runSpacing: 16,
//                 alignment: WrapAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: ConstrainedBox(
//                       constraints: const BoxConstraints(minWidth: 150, maxWidth: 200),
//                       child: AnimatedButton(
//                         text: 'deliver_to_address'.tr,
//                         onPressed: checkoutController.selectedAddress.value != null
//                             ? () => Get.back()
//                             : null,
//                         icon: Icons.check_circle,
//                         isDarkMode: isDarkMode,
//                       ),
//                     ),
//                   ),
//                   Flexible(
//                     child: ConstrainedBox(
//                       constraints: const BoxConstraints(minWidth: 150, maxWidth: 200),
//                       child: AnimatedButton(
//                         text: 'back_to_cart'.tr,
//                         onPressed: () => Get.toNamed('/cart'),
//                         icon: Icons.arrow_back,
//                         isDarkMode: isDarkMode,
//                       ),
//                     ),
//                   ),
//                 ],
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
//   final bool isDarkMode;
//   final bool isLoading;

//   const AnimatedButton({
//     required this.text,
//     this.onPressed,
//     this.icon,
//     required this.isDarkMode,
//     this.isLoading = false,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final RxBool isTapped = false.obs;

//     return GestureDetector(
//       onTapDown: onPressed != null && !isLoading ? (_) => isTapped.value = true : null,
//       onTapUp: onPressed != null && !isLoading
//           ? (_) {
//               isTapped.value = false;
//               onPressed!();
//             }
//           : null,
//       onTapCancel: onPressed != null && !isLoading ? () => isTapped.value = false : null,
//       child: Obx(
//         () => AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.bounceOut,
//           transform: Matrix4.identity()..scale((isTapped.value && !isLoading) ? 0.95 : 1.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isLoading) ...[
//                     const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation(Colors.white),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                   ] else if (icon != null) ...[
//                     Icon(
//                       icon,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                   Flexible(
//                     child: Text(
//                       text,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                       overflow: TextOverflow.ellipsis,
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
import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

class AddressSelectionView extends StatelessWidget {
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final RxBool isEditing = false.obs;
  final RxInt editingIndex = (-1).obs;

  AddressSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select_delivery_address'.tr,
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
              // Saved Addresses
              Text(
                'saved_addresses'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              if (checkoutController.savedAddresses.isEmpty)
                Text(
                  'no_addresses'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              else
                ...checkoutController.savedAddresses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final address = entry.value;
                  return Card(
                    elevation: 4,
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: RadioListTile<Address>(
                      title: Text(
                        address.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        '${address.streetAddress}, ${address.city}, ${address.postalCode}, ${address.country}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      value: address,
                      groupValue: checkoutController.selectedAddress.value,
                      onChanged: (value) => checkoutController.selectAddress(value),
                      secondary: IconButton(
                        icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          isEditing.value = true;
                          editingIndex.value = index;
                          checkoutController.selectAddress(address);
                        },
                      ),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }).toList(),
              const SizedBox(height: 16),

              // Add/Edit Address Form
              Text(
                isEditing.value ? 'edit_address'.tr : 'add_new_address'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => checkoutController.fullName.value = value,
                decoration: InputDecoration(
                  labelText: 'full_name'.tr,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => checkoutController.streetAddress.value = value,
                decoration: InputDecoration(
                  labelText: 'street_address'.tr,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  prefixIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => checkoutController.city.value = value,
                decoration: InputDecoration(
                  labelText: 'city'.tr,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  prefixIcon: Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => checkoutController.postalCode.value = value,
                decoration: InputDecoration(
                  labelText: 'postal_code'.tr,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  prefixIcon: Icon(Icons.local_post_office, color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => checkoutController.country.value = value,
                decoration: InputDecoration(
                  labelText: 'country'.tr,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  prefixIcon: Icon(Icons.flag, color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(height: 16),
              Center(
                child: AnimatedButton(
                  text: isEditing.value ? 'update_address'.tr : 'save address'.tr,
                  onPressed: () {
                    if (isEditing.value) {
                      checkoutController.updateAddress(editingIndex.value);
                    } else {
                      checkoutController.addNewAddress();
                    }
                  },
                  icon: Icons.save,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120, maxWidth: 180),
                      child: AnimatedButton(
                        text: 'deliver to address'.tr,
                        onPressed: checkoutController.selectedAddress.value != null
                            ? () => Get.back()
                            : null,
                        icon: Icons.check_circle,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120, maxWidth: 180),
                      child: AnimatedButton(
                        text: 'back to cart'.tr,
                        onPressed: () => Get.toNamed('/cart'),
                        icon: Icons.arrow_back,
                        isDarkMode: isDarkMode,
                      ),
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
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