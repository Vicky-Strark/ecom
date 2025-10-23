

import 'dart:convert';
import 'package:ecom/Shared/shared.dart';
import 'package:http/http.dart' as http;

import '../Errors/errors.dart';

import 'dart:async';
import 'dart:io';

import '../UseCase/shared_service.dart';




class ApiClient {
  apiPost({givenUrl, body}) async {

    // final token = await SharedPrefService().getAuthToken();
    final token = "";
    final url = Uri.parse(givenUrl);
    print("url in ser ==> $url");
    // Logger().i(body);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ""}',
    };
    print("headers in ser ==> $headers");

    var response = await http.post(url, body: json.encode(body),

        headers: headers

    );

    print("response ===> ${response.body}" );
    print("response ===> ${response.request}" );
    print("headers ===> ${response.headers}" );
    try {

      print("${response.statusCode}-${response.reasonPhrase}");

      final  decodeData = await json.decode(response.body);

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Logger().d("==>>>${response.statusCode}-${response.body}<<<==");
        return decodeData ;
      }
      else {

        print("====>${response.statusCode}-${response.body}<====");
        // Logger().d(json.decode(response.body));
        return "${response.statusCode}-${decodeData["Message"]}";
      }
    } on SocketException {

      return "No Internet Connection";
    } on TimeoutException{
      return "Server Time Out";
    }

    on Error catch (e) {
      print("err in er_catch-----------------");

      return e.toString();
    } catch (e) {
      print("Er in service--------------------");

      return "${response.statusCode}-${response.reasonPhrase}";
    }
  }
  apiPut({givenUrl, body}) async {

    // final token = await SharedPrefService().getAuthToken();
    final token = "";
    final url = Uri.parse(givenUrl);
    print("url in ser ==> $url");
    print("body in ser ==> $body");
    var headers = {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'accept': '*/*',
      'Referer': 'https://localhost:7017/swagger/index.html',
      'Authorization': 'Bearer ${token ?? ""}',
    };
    print("headers in ser ==> $headers");

    var response = await http.put(url, body: json.encode(body),

        headers: headers

    );


    try {

      print("${response.statusCode}-${response.reasonPhrase}");

      final  decodeData = await json.decode(response.body);

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        print("==>>>${response.statusCode}-${response.body}<<<==");
        return decodeData ;
      }
      else {

        print("====>${response.statusCode}-${response.body}<====");
        print(json.decode(response.body));
        return "${response.statusCode}-${decodeData["Message"]}";
      }
    } on SocketException {

      return "No Internet Connection";
    } on TimeoutException{
      return "Server Time Out";
    }

    on Error catch (e) {
      print("err in er_catch");
      return e.toString();
    } catch (e) {
      print("Er in service $e");
      return "${response.statusCode}-${response.reasonPhrase}";
    }
  }
  apiDelete({givenUrl, body}) async {

    // final token = await SharedPrefService().getAuthToken();
    final token ="";
    final url = Uri.parse(givenUrl);
    print("url in ser ==> $url");
    print("body in ser ==> $body");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ""}',
    };
    print("headers in ser ==> $headers");

    var response = await http.delete(url, body: json.encode(body),

        headers: headers

    );

    print("response ===> ${response.body}" );
    print("response ===> ${response.request}" );
    print("headers ===> ${response.headers}" );
    try {

      print("${response.statusCode}-${response.reasonPhrase}");

      final  decodeData = await json.decode(response.body);

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        print("==>>>${response.statusCode}-${response.body}<<<==");
        return decodeData ;
      }
      else {

        print("====>${response.statusCode}-${response.body}<====");
        print(json.decode(response.body));
        return "${response.statusCode}-${decodeData["Message"]}";
      }
    } on SocketException {

      return "No Internet Connection";
    } on TimeoutException{
      return "Server Time Out";
    }

    on Error catch (e) {
      print("err in er_catch");
      return e.toString();
    } catch (e) {
      print("Er in service $e");
      return "${response.statusCode}-${response.reasonPhrase}";
    }
  }
  apiPostWithoutToken({givenUrl, body}) async {


    final token ="";
    final url = Uri.parse(givenUrl);
    print("url in ser ==> $url");
    print("body in ser ==> $body");
    var response = await http.post(url, body: json.encode(body),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }

    ).timeout(Duration(seconds: 15));

    print("response ===> ${response.body}" );
    print("response ===> ${response.request}" );
    try {

      print("${response.statusCode}-${response.reasonPhrase}");

      final  decodeData = await json.decode(response.body);

      if (response.statusCode == 200) {
        return decodeData ;
      }
      else {

        print("====>${response.statusCode}-${response.body}<====");
        print(json.decode(response.body));
        return jsonDecode(response.body);

      }
    }on ServerException{


      return  ServerException(
        response.body
      );
    }

    on SocketException {
      print("socket exception");

      return "No Internet Connection";
    } on TimeoutException{
      print("time out exception");
      throw TimeoutException("dsnfasdfafasfasf");
      return "Server Time Out";
    }

    on Error catch (e) {
      print("err in er_catch");
      return e.toString();
    } catch (e) {
      print("Er in service $e");
      return "${response.statusCode}-${response.reasonPhrase}";
    }
  }


  apiGet({givenUrl}) async {
    final token = await SharedPrefService().getAuthToken();

    final url = Uri.parse(givenUrl);

    Map<String,String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',


      // 'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ""}',
    };
    var response = await http.get(url,
        headers:headers );
    print("url in ser ==> $url");
    print("url in header ==> $headers");
    print("response in service ==> ${response.body}");
    print("response in service ==> ${response}");




    try {

      if(response.statusCode == 200){
        print("data => ${json.decode(response.body)}");
        // Logger().i(json.decode(response.body));
        return response;
      }else{
        return "${response.statusCode}-${response.reasonPhrase}";
      }

    }
    on SocketException{
      return "No Internet Connection";
    }on Error catch(e){
      print("er in ercatch $e");
      return e.toString();
    }



    catch (e) {
      print("er in get ser ==> $e");

      return e.toString();
    }
  }
}



