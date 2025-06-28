// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getx_chapter_1/app/modules/product/controllers/product_controller.dart';
// import 'package:getx_chapter_1/app/services/theme_service.dart';
// import '../models/product_model.dart';

// class ProductView extends StatelessWidget {
//   final ProductController productController = Get.find<ProductController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('product_list'.tr),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.language),
//             tooltip: 'language'.tr,
//             onPressed: () {
//               if (Get.locale == Locale('en', 'US')) {
//                 Get.updateLocale(Locale('es', 'ES'));
//               } else {
//                 Get.updateLocale(Locale('en', 'US'));
//               }
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.brightness_6),
//             tooltip: 'theme'.tr,
//             onPressed: () => ThemeService().switchTheme(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) => productController.filterProducts(value),
//               decoration: InputDecoration(
//                 labelText: 'search_products'.tr,
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (productController.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (productController.errorMessage.isNotEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(productController.errorMessage.value),
//                       SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () => productController.fetchProducts(),
//                         child: Text('retry'.tr),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return ListView.builder(
//                 itemCount: productController.filteredProductList.length,
//                 itemBuilder: (context, index) {
//                   final product = productController.filteredProductList[index];
//                   return AnimatedListItem(
//                     key: ValueKey(product.id),
//                     product: product,
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AnimatedListItem extends StatefulWidget {
//   final ProductModel product;

//   AnimatedListItem({required Key key, required this.product}) : super(key: key);

//   @override
//   _AnimatedListItemState createState() => _AnimatedListItemState();
// }

// class _AnimatedListItemState extends State<AnimatedListItem> {
//   bool _isTapped = false;

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: CurvedAnimation(
//         parent: ModalRoute.of(context)!.animation ?? AlwaysStoppedAnimation(1.0),
//         curve: Curves.easeIn,
//       ),
//       child: GestureDetector(
//         onTapDown: (_) => setState(() => _isTapped = true),
//         onTapUp: (_) => setState(() => _isTapped = false),
//         onTapCancel: () => setState(() => _isTapped = false),
//         onTap: () => Get.toNamed('/product-details', arguments: widget.product),
//         child: AnimatedScale(
//           scale: _isTapped ? 0.95 : 1.0,
//           duration: Duration(milliseconds: 100),
//           child: Card(
//             margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: ListTile(
//               leading: Image.network(
//                 widget.product.image,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
//               ),
//               title: Text(widget.product.title),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('${'price'.tr}: \$${widget.product.price.toStringAsFixed(2)}'),
//                   Text('${'category'.tr}: ${widget.product.category}'),
//                   Text('${'rating'.tr}: ${widget.product.rating.rate} (${widget.product.rating.count} ${'reviews'.tr})'),
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
import 'package:getx_chapter_1/app/modules/product/controllers/product_controller.dart';
import 'package:getx_chapter_1/app/services/theme_service.dart';
import 'package:getx_chapter_1/app/services/language_selector.dart';
import '../models/product_model.dart';

class ProductView extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product_list'.tr),
        actions: [
          const LanguageSelector(),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'theme'.tr,
            onPressed: () => ThemeService().switchTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => productController.filterProducts(value),
              decoration: InputDecoration(
                labelText: 'search_products'.tr,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productController.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(productController.errorMessage.value),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => productController.fetchProducts(),
                        child: Text('retry'.tr),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: productController.filteredProductList.length,
                itemBuilder: (context, index) {
                  final product = productController.filteredProductList[index];
                  return AnimatedListItem(
                    key: ValueKey(product.id),
                    product: product,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final ProductModel product;

  const AnimatedListItem({required Key key, required this.product}) : super(key: key);

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ModalRoute.of(context)!.animation ?? const AlwaysStoppedAnimation(1.0),
        curve: Curves.easeIn,
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: () => Get.toNamed('/product-details', arguments: widget.product),
        child: AnimatedScale(
          scale: _isTapped ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Image.network(
                widget.product.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
              title: Text(widget.product.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${'price'.tr}: \$${widget.product.price.toStringAsFixed(2)}'),
                  Text('${'category'.tr}: ${widget.product.category}'),
                  Text('${'rating'.tr}: ${widget.product.rating.rate} (${widget.product.rating.count} ${'reviews'.tr})'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
