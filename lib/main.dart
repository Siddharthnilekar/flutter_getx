import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/services/cart_service.dart';
import 'package:getx_chapter_1/app/services/theme_service.dart';
import 'package:getx_chapter_1/app/services/translations.dart';
import 'app/routes/app_pages.dart';

void main() async {
  Get.put(CartService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      translations: AppTranslations(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeService().theme,
      initialRoute: Routes.PRODUCT,
      getPages: AppPages.routes,
    );
  }
}
