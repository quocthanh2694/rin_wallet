import 'package:bloc/bloc.dart';
import 'package:rin_wallet/src/ui/page/notification/counter_state.dart';

/// {@template counter_cubit}
/// A [Cubit] which manages an [int] as its state.
/// {@endtemplate}
class CounterCubit extends Cubit<CounterState> {
  /// {@macro counter_cubit}
  CounterCubit() : super(CounterState());

  /// Add 1 to the current state.
  void increment() {
    state.count = state.count! + 1;
    CounterState newState = CounterState.fromObject(state);
    emit(newState);
  }

  /// Subtract 1 from the current state.
  void decrement() {
    state.count = state.count! - 1;
    CounterState newState = CounterState.fromObject(state);
    emit(newState);
  }
}
