part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class FetchHomeEvent extends HomeEvent {
  final int? limit;

  const FetchHomeEvent({
    this.limit,
  });

  @override
  List<Object> get props => [
        limit.toString(),
      ];
}

final class FetchMoreHomeEvent extends HomeEvent {
  final int? limit;
  final List<Transaction>? transactions;
  final String? lastId;
  final String? firstId;

  const FetchMoreHomeEvent({
    this.limit,
    this.transactions,
    this.lastId,
    this.firstId,
  });

  @override
  List<Object> get props => [
        limit.toString(),
        transactions.toString(),
        lastId.toString(),
        firstId.toString(),
      ];
}
