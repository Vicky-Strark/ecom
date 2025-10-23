import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefService{

  static const String userId = "userId";
  static const String name = "userName";
  static const String email = "email";
  static const String phone = "phone";
  static const String countryId = "countryId";
  static const String lanId = "lanId";
  static const String authToken = "authToken";


  static const String ciSession = "ciSession";


  static const String language = "language";
  static const String locale = "locale";
  static const String isExternal = "isexternal";



  static const String gender = "Gender";







  /// set data functions

  setUserId(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(userId, "${val}");
  }
  setUserEmail(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(email, "${val}");
  }
  setUserName(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(name, "${val}");
  }
  setUserPhone(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(phone, "${val}");
  }
  setUserCountryId(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(countryId, "${val}");
  }
  setUserLanId(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(lanId, "${val}");
  }




  setAuthToken(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(authToken, "${val}");
  }
  setCiSession(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(ciSession, "${val}");
  }


  setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(language, locale.languageCode);
  }

  setIsExteral(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isExternal, val );
  }







  /// get data funcions

  getUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userId);
  }
  getUserEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(email);
  }
  getUserName()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(name);
  }
  getUserPhone()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(phone);
  }
  getUserCountryId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(countryId);
  }
  getUserLanId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(lanId);
  }

  getAuthToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(authToken);
  }
  getCiSession()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(ciSession);
  }


  Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(language) ?? 'ar';
    print(languageCode);
    return Locale(languageCode);
  }




  remove({val})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(val);
  }



  /// clear all shared value
  clearAll()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }}


