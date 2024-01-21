import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wheredidispend/models/transaction.dart';
import 'package:wheredidispend/repositories/transaction_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchHomeEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await TransactionRepository.getTransactions(
        limit: event.limit,
      );
      log(result.toString());
      if (result.success) {
        emit(HomeSuccess(result.data!));
      } else {
        emit(HomeFailure(result.message ?? "Something went wrong!"));
      }
    });
    on<FetchMoreHomeEvent>((event, emit) async {
      emit(HomeLoadingMore(transactions: event.transactions ?? []));
      final result = await TransactionRepository.getTransactions(
        limit: event.limit,
        lastId: event.lastId,
        firstId: event.firstId,
      );

      if (result.success) {
        final List<Transaction> transactions = event.transactions ?? [];
        transactions.addAll(result.data!);
        transactions.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        log("Success!!! ${transactions.toString()}");
        emit(HomeSuccess(transactions));
      } else {
        emit(HomeFailure(result.message ?? "Something went wrong!"));
      }
    });
  }
}
