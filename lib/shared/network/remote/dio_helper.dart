import 'package:dio/dio.dart';
import 'package:shop_app/stripe_payment/stripe_keys.dart';

class DioHelper {

  static Dio? dio;

  static int() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com/',
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(
          milliseconds: 5000000,
        ),
        receiveTimeout: Duration(
          milliseconds: 5000000,
        ),
      ),

    );
  }


  static Future<Response>getData({
required String url,
})
   async{
     return await dio!.get(url);
       }


  static Future<Response> postData({
    required String url,
    required Map<String,dynamic> data,
  })async{
    dio!.options.headers={
      'Content-Type':'application/x-www-form-urlencoded',
      'Authorization':'Bearer ${ApiKeys.secretKey}',
    };
    return await dio!.post(
      url,
      data: data,
    );
  }
   }