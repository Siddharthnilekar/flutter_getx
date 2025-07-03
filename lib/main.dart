import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_chapter_1/app/routes/app_pages.dart';
import 'package:getx_chapter_1/app/services/translations.dart';
import 'package:getx_chapter_1/app/services/theme_service.dart';

void main() async {
  await GetStorage.init();
  final storage = GetStorage();
  // Load saved locale, default to en_US if invalid
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
      initialRoute: Routes.PRODUCT,
      getPages: AppPages.routes,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}