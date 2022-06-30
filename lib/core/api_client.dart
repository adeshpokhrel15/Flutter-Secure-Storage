import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(baseUrl: "http://localhost:3000/api/"),
  );

  postData({required Map<String, dynamic> formData}) async {
    try {
      final result = await dio.post("post/like-post", data: formData);
      log(result.toString());
    } on DioError catch (e) {
      log(e.response!.data.toString());
    }
  }

  getData({required String endpoint}) async {
    final Dio newDio = Dio();
    final Options cacheOptions = buildCacheOptions(
      const Duration(days: 7),
      forceRefresh: true,
    );
    newDio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);
    try {
      final result = await newDio.get(endpoint, options: cacheOptions);

      return result.data;
    } on DioError catch (e) {
      throw Exception(e);
    }
  }
}
