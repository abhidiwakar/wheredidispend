import 'package:equatable/equatable.dart';

class TransactionAverage extends Equatable {
  final double averageSpending;

  const TransactionAverage({required this.averageSpending});

  TransactionAverage.fromJson(Map<String, dynamic> json)
      : averageSpending = double.parse(json['averageSpending'].toString());

  static List<TransactionAverage> fromJsonList(List<dynamic> json) {
    return json.map((e) => TransactionAverage.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["averageSpending"] = averageSpending;
    return data;
  }

  @override
  List<Object?> get props => [averageSpending];
}
