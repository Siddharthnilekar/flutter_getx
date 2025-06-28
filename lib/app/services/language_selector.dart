import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: 'language'.tr,
      onPressed: () {
        Get.bottomSheet(
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: Image.asset('assets/images/uk_flag.png', width: 24, height: 24),
                  title: const Text('English'),
                  trailing: Get.locale == const Locale('en', 'US') ? const Icon(Icons.check) : null,
                  onTap: () {
                    Get.updateLocale(const Locale('en', 'US'));
                    GetStorage().write('locale', 'en_US');
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/spain_flag.png', width: 24, height: 24),
                  title: const Text('Español'),
                  trailing: Get.locale == const Locale('es', 'ES') ? const Icon(Icons.check) : null,
                  onTap: () {
                    Get.updateLocale(const Locale('es', 'ES'));
                    GetStorage().write('locale', 'es_ES');
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}