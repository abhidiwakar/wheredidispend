part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoadingMore extends HomeState {
  final List<Transaction> transactions;

  const HomeLoadingMore({required this.transactions});

  @override
  List<Object> get props => [transactions.toString()];
}

final class HomeSuccess extends HomeState {
  final List<Transaction> transactions;

  const HomeSuccess(this.transactions);

  @override
  List<Object> get props => [transactions];
}

final class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class HomeLoadingMoreFailure extends HomeState {
  final String message;
  final List<Transaction> transactions;

  const HomeLoadingMoreFailure(
      {required this.message, required this.transactions});

  @override
  List<Object> get props => [message, transactions.toString()];
}
