// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:getx_chapter_1/app/bindings/ProductBinding.dart';
// import 'package:getx_chapter_1/app/modules/product/view/cart_view.dart';
// import 'package:getx_chapter_1/app/modules/product/view/checkout_view.dart';
// import 'package:getx_chapter_1/app/modules/product/view/product_details_view.dart';
// import 'package:getx_chapter_1/app/modules/product/view/product_view.dart';
// import 'package:getx_chapter_1/app/services/translations.dart';

// void main() async {
//   await GetStorage.init();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shopping App',
//       translations: AppTranslations(),
//       locale: Locale('en', 'US'),
//       fallbackLocale: Locale('en', 'US'),
//       initialRoute: '/product',
//       getPages: [
//         GetPage(
//           name: '/product',
//           page: () => ProductView(),
//           binding: ProductBinding(),
//         ),
//         GetPage(
//           name: '/product-details',
//           page: () => ProductDetailsView(),
//           binding: ProductBinding(),
//         ),
//         GetPage(
//           name: '/cart',
//           page: () => CartView(),
//           binding: ProductBinding(),
//         ),
//         GetPage(
//           name: '/checkout',
//           page: () => CheckoutView(),
//           binding: ProductBinding(),
//         ),
//       ],
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: ThemeMode.system,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_chapter_1/app/bindings/ProductBinding.dart';
import 'package:getx_chapter_1/app/modules/product/view/cart_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/checkout_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/product_details_view.dart';
import 'package:getx_chapter_1/app/modules/product/view/product_view.dart';
import 'package:getx_chapter_1/app/services/translations.dart';
import 'package:getx_chapter_1/app/services/theme_service.dart';

void main() async {
  await GetStorage.init();
  final storage = GetStorage();
  // Load saved locale, default to en_US if invalid or hi_IN
  final savedLocale = storage.read('locale') ?? 'en_US';
  final validLocales = ['en_US', 'es_ES'];
  final localeString = validLocales.contains(savedLocale) ? savedLocale : 'en_US';
  final localeParts = localeString.split('_');
  final locale = Locale(localeParts[0], localeParts[1]);
  // Load theme
  final themeService = ThemeService();

  runApp(MyApp(initialLocale: locale, initialTheme: themeService.theme));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  final ThemeMode initialTheme;

  MyApp({required this.initialLocale, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      themeMode: initialTheme,
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
    );
  }
}