import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/product_controller.dart';
import 'package:getx_chapter_1/app/services/cart_service.dart';
import 'package:getx_chapter_1/app/services/product_service.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductService>(() => ProductService());
    Get.lazyPut<CartService>(() => CartService());
    Get.lazyPut<ProductController>(() => ProductController(productService: Get.find<ProductService>()));
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}