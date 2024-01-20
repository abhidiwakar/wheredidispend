import 'package:equatable/equatable.dart';

class HttpResponse<T> extends Equatable {
  final int? statusCode;
  final T? data;
  final String? message;
  final bool success;

  const HttpResponse(
    this.success, {
    this.statusCode,
    this.data,
    this.message,
  });

  static getMessage(dynamic message) {
    if (message is List) {
      return message.elementAtOrNull(0);
    } else if (message is String) {
      return message;
    } else {
      return null;
    }
  }

  @override
  List<Object?> get props => [success, statusCode, data, message];
}
