import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:wheredidispend/models/transaction.dart';
import 'package:wheredidispend/utils/dio.dart';
import 'package:wheredidispend/utils/http.dart';

class TransactionRepository {
  static Future<HttpResponse<List<Transaction>>> getTransactions(
      {String? lastId, String? firstId, int limit = 20}) async {
    try {
      final params = {
        if (firstId != null) "firstId": firstId,
        if (lastId != null) "lastId": lastId,
        "limit": limit,
      };
      final result = await ApiService("/transaction").dio.get(
            '/get',
            queryParameters: params,
          );
      log(jsonEncode(result.data));
      return HttpResponse(
        true,
        data: Transaction.fromJsonList(result.data),
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

  static Future<HttpResponse> addTransaction(Transaction transaction) async {
    try {
      final result = await ApiService("/transaction").dio.post(
            '/add',
            data: transaction.toJson(),
          );
      return HttpResponse(
        true,
        data: result.data,
        message: HttpResponse.getMessage(result.data['message']) ??
            "Transaction added successfully!",
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
      return const HttpResponse(false, message: "Something went wrong!");
    }
  }
}
