import 'package:flutter_bloc/flutter_bloc.dart';

// class CounterBloc extends Bloc<CounterEvent, int> {
//   CounterBloc() : super(5) {
//     on<CounterIncEvent>(_onCounterIncEvent);
//     on<CounterDecEvent>(_onCounDecIncEvent);
//   }
//   _onCounterIncEvent(CounterIncEvent event, Emitter<int> emit) {
//     emit(state + 1);
//   }

//   _onCounDecIncEvent(CounterDecEvent event, Emitter<int> emit) {
//     if (state <= 0) return;
//     emit(state - 1);
//   }
// }

// abstract class CounterEvent {}

// class CounterIncEvent extends CounterEvent {}

// class CounterDecEvent extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(5) {
    on<CounterIncEvent>(_onCounterIncEvent);
    on<CounterDecEvent>(_onCounterDecEvent);
  }
  _onCounterIncEvent(CounterIncEvent event, Emitter<int> emit) {
    emit(state + 1);
  }

  _onCounterDecEvent(CounterDecEvent event, Emitter<int> emit) {
    if (state <= 0) return;
    emit(state - 1);
  }
}

abstract class CounterEvent {}

class CounterIncEvent extends CounterEvent {}

class CounterDecEvent extends CounterEvent {}
