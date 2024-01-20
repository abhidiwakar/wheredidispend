import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:wheredidispend/utils/dio.dart';
import 'package:wheredidispend/utils/http.dart';

class ProfileRepository {
  static Future<HttpResponse> deleteAccount() async {
    try {
      final result = await ApiService("/user").dio.delete(
            '/delete',
          );
      await FirebaseAuth.instance.signOut();
      return HttpResponse(
        true,
        message: HttpResponse.getMessage(result.data['message']) ??
            "Account deleted successfully!",
      );
    } on DioException catch (e) {
      return HttpResponse(
        false,
        message: HttpResponse.getMessage(e.response?.data['message']) ??
            "Unknown error occured!",
      );
    } on SocketException {
      return const HttpResponse(false, message: "No internet connection!");
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      // log(e.toString());
      return const HttpResponse(false, message: "Something went wrong!");
    }
  }
}
