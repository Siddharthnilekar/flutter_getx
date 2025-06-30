import 'package:get/get.dart';
import 'package:getx_chapter_1/app/services/product_service.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var productList = <ProductModel>[].obs;
  var filteredProductList = <ProductModel>[].obs;
  var errorMessage = ''.obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs; // Changed to RxString

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
    searchQuery.value = query.trim(); // Update searchQuery and trim input
    if (searchQuery.value.isEmpty) {
      filteredProductList.assignAll(productList);
    } else {
      filteredProductList.assignAll(
        productList.where((product) =>
            product.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList(),
      );
    }
  }
}