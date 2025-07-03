import 'package:get/get.dart';
import 'package:getx_chapter_1/app/bindings/ProductBinding.dart';
import 'package:getx_chapter_1/app/modules/product/view/cart_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/checkout_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/payment_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/product_details_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/product_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/address_selection_view.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.PRODUCT,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () => ProductDetailsView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => CartView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => CheckoutView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => PaymentView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.ADDRESS_SELECTION,
      page: () => AddressSelectionView(),
      binding: ProductBinding(),
    ),
  ];
}