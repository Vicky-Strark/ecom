import 'dart:convert';
import 'package:ecom/Core/core.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../Core/Errors/errors.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  Future<ProfileModel> fetchProfile({required int userId}) async {
    try {
       final box = await Hive.openBox('productsBox');
      if (box.containsKey('user_$userId')) {
        try {
          final cachedProfile = box.get('user_$userId');
          if (cachedProfile != null) {
            print("Returning cached profile for user $userId");
            return cachedProfile;
          }
        } catch (cacheError) {
          print("Cache read error: $cacheError");
        }
      }
      final response = await ApiClient().apiGet(
        givenUrl: '${AppUrl.getUsers}/$userId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final profile = ProfileModel.fromJson(data);

        try {
          await box.put('user_$userId', profile);
          print("Profile cached for user $userId");
        } catch (e) {
          print("Cache write error: $e");
        }

        return profile;
      } else {
        throw ServerException(
          "Failed to load profile (Code: ${response.statusCode})",
        );
      }
    } on ServerException {
      rethrow;
    } on http.ClientException {
      throw NetworkException("No Internet Connection");
    } catch (e) {
      print("Error in fetchProfile: $e");

      try {
        final box = Hive.isBoxOpen('profileBox')
            ? Hive.box<ProfileModel>('profileBox')
            : await Hive.openBox<ProfileModel>('profileBox');

        if (box.containsKey('user_$userId')) {
          final cachedProfile = box.get('user_$userId');
          if (cachedProfile != null) {
            return cachedProfile;
          }
        }
      } catch (fallbackError) {
        print("Fallback cache error: $fallbackError");
      }

      throw SomethingWrongException("Something went wrong: ${e.toString()}");
    }
  }
}
