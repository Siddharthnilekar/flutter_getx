import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/models/product_model.dart';
import 'package:getx_chapter_1/app/services/product_service.dart';

class ProductController extends GetxController {
  var productList = <ProductModel>[].obs;
  var filteredProductList = <ProductModel>[].obs;
  var errorMessage = ''.obs;
  var isLoading = true.obs;

  final ProductService productService;

  ProductController({required this.productService});

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      errorMessage('');
      var products = await productService.fetchProducts();
      productList.assignAll(products);
      filteredProductList.assignAll(products);
    } catch (e) {
      errorMessage('Failed to fetch products: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProductList.assignAll(productList);
    } else {
      filteredProductList.assignAll(
        productList.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}