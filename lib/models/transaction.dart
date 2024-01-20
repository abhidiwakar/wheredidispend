import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String? id;
  final String? description;
  final double amount;
  final DateTime date;
  final String? currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Transaction({
    this.id,
    this.description,
    required this.amount,
    required this.date,
    this.currency,
    this.createdAt,
    this.updatedAt,
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        description = json['description'] as String?,
        amount = double.parse(json['amount'].toString()),
        date = DateTime.parse(
          json['date'] as String,
        ),
        createdAt = DateTime.parse(
          json['createdAt'] as String,
        ),
        updatedAt = DateTime.parse(
          json['updatedAt'] as String,
        ),
        currency = json['currency'] as String;

  static List<Transaction> fromJsonList(List<dynamic> json) {
    return json.map((e) => Transaction.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["description"] = description;
    data["amount"] = amount;
    data["date"] = date.toIso8601String();
    data["currency"] = currency;
    data["createdAt"] = createdAt?.toIso8601String();
    data["updatedAt"] = updatedAt?.toIso8601String();
    return data;
  }

  @override
  List<Object?> get props => [id, description, amount, date, currency];
}
