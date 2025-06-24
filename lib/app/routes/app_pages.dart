
import 'package:get/get.dart';
import '../modules/product/view/product_details_view.dart';
import '../modules/product/view/product_view.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.PRODUCT,
      page: () => ProductView(),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () => ProductDetailsView(),
    ),
  ];
}
