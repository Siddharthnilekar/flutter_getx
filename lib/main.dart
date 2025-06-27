import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_chapter_1/app/bindings/ProductBinding.dart';
import 'package:getx_chapter_1/app/modules/product/view/cart_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/checkout_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/product_details_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/product_view.dart';
import 'package:getx_chapter_1/app/services/translations.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      translations: AppTranslations(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      initialRoute: '/product',
      getPages: [
        GetPage(
          name: '/product',
          page: () => ProductView(),
          binding: ProductBinding(),
        ),
        GetPage(
          name: '/product-details',
          page: () => ProductDetailsView(),
          binding: ProductBinding(),
        ),
        GetPage(
          name: '/cart',
          page: () => CartView(),
          binding: ProductBinding(),
        ),
        GetPage(
          name: '/checkout',
          page: () => CheckoutView(),
          binding: ProductBinding(),
        ),
      ],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}