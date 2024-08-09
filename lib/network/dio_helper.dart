import 'dart:core';
import 'package:dio/dio.dart';
class DioHelper {
  static Dio dio=Dio();
  static init()
  {
    dio = Dio(
      BaseOptions
      (
        baseUrl: 'http://192.168.1.7/api/',
      receiveDataWhenStatusError: true,
      headers:
       {
          'Content-Type':'application/json',

       })


    );
  }
  static Future<Response> getData ({ 
    required String url,
  })async
  {
    return await dio.get(url,
);
  }
  static Future<Response> postData(
    {
      required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic> data,
    }
  )async
  {
return dio.post(
  url,
  queryParameters: query,
  data: data,
  );
  }
}