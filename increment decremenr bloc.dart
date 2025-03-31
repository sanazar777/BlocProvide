// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CounterEvent {}

class IncrementCounter extends CounterEvent {}

class DecrementCounter extends CounterEvent {}

abstract class CounterState {}

class CounterInitial extends CounterState {
  final int counter;
  CounterInitial(this.counter);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial(0)) {
    on<IncrementCounter>(
      (event, emit) =>
          emit(CounterInitial((state as CounterInitial).counter + 1)),
    );
    on<DecrementCounter>(
      (event, emit) =>
          emit(CounterInitial((state as CounterInitial).counter - 1)),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: CounterPage(),
      ),
    ),
  );
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            if (state is CounterInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Counter: ${state.counter}',
                    style: TextStyle(fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed:
                            () => context.read<CounterBloc>().add(
                              IncrementCounter(),
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed:
                            () => context.read<CounterBloc>().add(
                              DecrementCounter(),
                            ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
