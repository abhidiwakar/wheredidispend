import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wheredidispend/utils/constants.dart';

class ApiService {
  final _basePath = baseAPIURL;
  final dio = Dio();

  ApiService(String path) {
    dio.options.baseUrl = _basePath + path;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          options.headers["authorization"] = "Bearer $token";
          log("Bearer $token");
        }

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        options.headers["x-app-version"] =
            '${packageInfo.version}.${packageInfo.buildNumber}';
        return handler.next(options);
      },
      onError: (error, handler) async {
        log(error.toString());
        if (error.response?.statusCode == 401) {
          await FirebaseAuth.instance.signOut();
        }
        return handler.next(error);
      },
    ));
  }
}
