import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modules/product/models/product_model.dart';

class ProductService {
  final String apiUrl = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((productJson) => ProductModel.fromJson(productJson)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}