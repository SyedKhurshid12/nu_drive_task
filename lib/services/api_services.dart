// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nu_drive_task/Config/const_url.dart';
import 'package:nu_drive_task/models/services_model.dart';

class ApiServices {
  late Response response;

  ///type is api type get or post 0 for get and 1 for post
  Future<Response> dioConnect(url, data, apiToken, apiType, contentType,
      {bool? search}) async {
    Dio dio = Dio();
    print('url : $url');
    print('postData : ${jsonEncode(data.toString())}');
    print('apiType : $apiType');
    print('contentType : $contentType');
    // dio.interceptors.add(RetryInterceptor(
    //   dio: dio,
    //   logPrint: print, // specify log function (optional)
    //   retries: 3, // retry count (optional)
    //   retryDelays: const [ // set delays be
    //     Duration(seconds: 5), // wait 3 sec before third retry
    //   ],
    // ));
    try {
      dio.options.connectTimeout = const Duration(milliseconds: 15000);
      dio.options.receiveTimeout = const Duration(milliseconds: 15000);

      if (contentType == 'form') {
        dio.options.headers['content-Type'] =
            'application/x-www-form-urlencoded';
      } else {
        dio.options.headers['content-Type'] = 'application/json';
      }
      if (apiType == 'get') {
        if (apiToken.runtimeType != String) {
          return await dio.get(url, cancelToken: apiToken);
        } else {
          return await dio.get(url);
        }
      } else if (apiType == 'post') {
        if (apiToken.runtimeType != String) {
          return await dio.post(url, data: data, cancelToken: apiToken);
        } else {
          return await dio.post(url, data: data);
        }
      } else if (apiType == 'put') {
        return await dio.put(url, data: data);
      } else {
        return await dio.delete(url, data: data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        int? statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          // Re-attempt the API call
          return await dioConnect(url, data, apiToken, apiType, contentType);
        } else if (statusCode == 404) {
          throw Exception("Api not found");
        } else if (statusCode == 400) {
          throw Exception("Internal Server Error");
        } else {
          throw Exception(e.error.toString());
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(e.message.toString());
      } else if (e.type == DioExceptionType.connectionError) {
        // Handle connection error (e.g., host lookup failures)
        throw DioException(
          requestOptions: e.requestOptions,
          response: Response(
            requestOptions: e.requestOptions,
            statusCode:
                -1, // You can use a custom status code for connection errors
          ),
          type: DioExceptionType.connectionError,
          // Use a custom error type for connection errors
          error:
              "Connection error. Please ensure you have a network connection.",
        );
      } else if (e.type == DioExceptionType.cancel) {
        throw Exception('Cancel Request');
      }
      throw Exception("Connection Error");
    } finally {
      dio.close();
    }
  }

  Future<ServicesModel> getServices() async {
    response = await dioConnect(serviceApi, "", "", 'get', null);
    print(jsonEncode(response.toString()));
    ServicesModel responseData = ServicesModel.fromJson(response.data);
    return responseData;
  }
}
