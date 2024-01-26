import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wheredidispend/repositories/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<TransactionGetAverageEvent>((event, emit) async {
      emit(TransactionAverageLoading());
      try {
        final averageSpending =
            await TransactionRepository.getAverageSpending();
        log(averageSpending.data.toString());
        if (averageSpending.success) {
          emit(TransactionAverageSuccess(averageSpending.data));
        } else {
          emit(
            TransactionAverageFailure(
              averageSpending.message ?? "Failed to get average spending!",
            ),
          );
        }
      } catch (e) {
        emit(
            const TransactionAverageFailure("Failed to get average spending!"));
      }
    });
  }
}
