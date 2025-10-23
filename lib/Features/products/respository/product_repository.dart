import 'dart:convert';
import 'package:ecom/Core/core.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../Core/Errors/errors.dart';
import '../model/product_model.dart';


class ProductRepository {

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final box = await Hive.openBox('productsBox');
      if (box.containsKey('products')) {
        try {
          final cachedData = box.get('products');

          if (cachedData != null && cachedData is List) {
            final cachedProducts = (cachedData as List)
                .map((e) {
              try {
                Map<String, dynamic> jsonMap;

                if (e is String) {
                  jsonMap = jsonDecode(e) as Map<String, dynamic>;
                } else if (e is Map) {
                  jsonMap = Map<String, dynamic>.from(e);
                } else {
                  jsonMap = jsonDecode(jsonEncode(e)) as Map<String, dynamic>;
                }
                if (jsonMap.containsKey('price')) {
                  if (jsonMap['price'] is int) {
                    jsonMap['price'] = (jsonMap['price'] as int).toDouble();
                  } else if (jsonMap['price'] is String) {
                    jsonMap['price'] = double.tryParse(jsonMap['price']) ?? 0.0;
                  }
                }

                return ProductModel.fromJson(jsonMap);
              } catch (e) {
                print("Error parsing cached product products: $e");
                return null;
              }
            })
                .whereType<ProductModel>()
                .toList();

            if (cachedProducts.isNotEmpty) {
              return cachedProducts;
            }
          }
        } catch (cacheError) {
          print("Cache read error: $cacheError");

        }
      }

      final response = await ApiClient().apiGet(givenUrl: AppUrl.getProducts);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        try {
          await box.put('products', data);
        } catch (e) {
          print("Cache write error: $e");
        }

        return data
            .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        throw ServerException("Failed to load products (Code: ${response.statusCode})");
      }

    } on ServerException {
      rethrow;
    } on http.ClientException {
      throw NetworkException("No Internet Connection");
    } catch (e) {
      print("Error in fetchProducts: $e");

      try {
        final box = await Hive.openBox('productsBox');
        if (box.containsKey('products')) {
          final cachedData = box.get('products');
          if (cachedData != null && cachedData is List) {
            final cachedProducts = (cachedData as List)
                .map((e) {
              try {
                Map<String, dynamic> jsonMap;

                if (e is String) {
                  jsonMap = jsonDecode(e) as Map<String, dynamic>;
                } else if (e is Map) {
                  jsonMap = Map<String, dynamic>.from(e);
                } else {
                  jsonMap = jsonDecode(jsonEncode(e)) as Map<String, dynamic>;
                }

                if (jsonMap.containsKey('price')) {
                  if (jsonMap['price'] is int) {
                    jsonMap['price'] = (jsonMap['price'] as int).toDouble();
                  } else if (jsonMap['price'] is String) {
                    jsonMap['price'] = double.tryParse(jsonMap['price']) ?? 0.0;
                  }
                }

                return ProductModel.fromJson(jsonMap);
              } catch (e) {
                return null;
              }
            })
                .whereType<ProductModel>()
                .toList();

            if (cachedProducts.isNotEmpty) {
              return cachedProducts; // Return all cached products
            }
          }
        }
      } catch (fallbackError) {
        print("Fallback cache error: $fallbackError");
      }

      throw SomethingWrongException("Something went wrong: ${e.toString()}");
    }
  }




  Future<List<ProductModel>> searchProducts({val})async{
    try{
      var response = await fetchProducts();
      print(response);
      print("search");
      return response;
    }catch(e){
      throw Exception("Failed to fetch search: $e");

    }
  }
}