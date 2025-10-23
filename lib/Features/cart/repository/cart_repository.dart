import 'package:hive/hive.dart';
import 'package:ecom/Features/cart/model/cart_model.dart';

class CartRepository {
  static const String _cartBoxName = 'cartBox';

  Future<List<CartModel>> fetchCart() async {
    try {
      final box = await Hive.openBox(_cartBoxName);

      List<CartModel> tempCart = [];
      List cartHive = box.values.toList();
      for(var i =0; i<cartHive.length; i++){
        print(cartHive[i]);
        print("cart hive data type ${cartHive[i].runtimeType}");
        tempCart.add(
          CartModel.fromJson(cartHive[i])
        );
      }

      return  tempCart;
    } catch (e) {
      throw Exception("Failed to fetch cart: $e");
    }
  }


  Future<void> addToCart(CartModel cartItem) async {
    try {
      final box = await Hive.openBox(_cartBoxName);

      final existingKey = _findItemKey(box, cartItem.id);

      if (existingKey != null) {
        final existingItem = Map<String, dynamic>.from(box.get(existingKey));
        final currentQuantity = existingItem['quantity'] ?? 1;
        existingItem['quantity'] = currentQuantity + 1;
        await box.put(existingKey, existingItem);
      } else {
        final key = 'cart_${cartItem.id}_${DateTime.now().millisecondsSinceEpoch}';
        await box.put(key, cartItem.toJson());
      }
    } catch (e) {
      throw Exception("Failed to add item to cart: $e");
    }
  }

  Future<void> removeFromCart(CartModel cartItem) async {
    try {
      final box = await Hive.openBox(_cartBoxName);

      final key = _findItemKey(box, cartItem.id);

      if (key != null) {
        final existingItem = Map<String, dynamic>.from(box.get(key));
        final currentQuantity = existingItem['quantity'] ?? 1;

        if (currentQuantity > 1) {
          existingItem['quantity'] = currentQuantity - 1;
          await box.put(key, existingItem);
        } else {
          await box.delete(key);
        }
      }
    } catch (e) {
      throw Exception("Failed to remove item from cart: $e");
    }
  }

  Future<void> deleteFromCart(CartModel cartItem) async {
    try {
      final box = await Hive.openBox(_cartBoxName);

      final key = _findItemKey(box, cartItem.id);

      if (key != null) {
        await box.delete(key);
      }
    } catch (e) {
      throw Exception("Failed to delete item from cart: $e");
    }
  }

  Future<void> clearCart() async {
    try {
      final box = await Hive.openBox(_cartBoxName);
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear cart: $e");
    }
  }


  String? _findItemKey(Box box, int? productId) {
    if (productId == null) return null;

    for (var key in box.keys) {
      final item = Map<String, dynamic>.from(box.get(key));
      if (item['id'] == productId) {
        return key;
      }
      print("Key ==> $key");
    }
    return null;
  }
}