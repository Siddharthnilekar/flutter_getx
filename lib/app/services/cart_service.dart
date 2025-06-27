import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../modules/product/models/product_model.dart';

class CartService extends GetxService {
  final storage = GetStorage();
  final _cartItems = <ProductModel, int>{}.obs;

  List<ProductModel> get cartItems => _cartItems.keys.toList();

  double get totalAmount => _cartItems.entries.fold(
        0.0,
        (sum, entry) => sum + (entry.key.price * entry.value),
      );

  @override
  void onInit() {
    super.onInit();
    List? storedCart = storage.read<List>('cartItems');
    if (storedCart != null) {
      // Convert stored list to map, counting duplicates
      final tempMap = <ProductModel, int>{};
      for (var item in storedCart.map((e) => ProductModel.fromJson(e))) {
        if (tempMap.containsKey(item)) {
          tempMap[item] = tempMap[item]! + 1;
        } else {
          tempMap[item] = 1;
        }
      }
      _cartItems.assignAll(tempMap);
    }

    ever(_cartItems, (_) {
      // Store as list for backward compatibility
      final List<Map<String, dynamic>> storedList = [];
      _cartItems.forEach((product, quantity) {
        for (var i = 0; i < quantity; i++) {
          storedList.add(product.toJson());
        }
      });
      storage.write('cartItems', storedList);
    });
  }

  void addToCart(ProductModel product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
  }

  void removeFromCart(ProductModel product) {
    if (_cartItems.containsKey(product) && _cartItems[product]! > 1) {
      _cartItems[product] = _cartItems[product]! - 1;
    } else {
      _cartItems.remove(product);
    }
  }

  void clearCart() {
    _cartItems.clear();
  }

  int getQuantity(ProductModel product) => _cartItems[product] ?? 0;
}