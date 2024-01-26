part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

final class TransactionAverageLoading extends TransactionState {}

final class TransactionAverageSuccess extends TransactionState {
  final double? averageSpending;

  const TransactionAverageSuccess(this.averageSpending);

  @override
  List<Object> get props => [averageSpending!];
}

final class TransactionAverageFailure extends TransactionState {
  final String message;

  const TransactionAverageFailure(this.message);

  @override
  List<Object> get props => [message];
}
