import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_project/counter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (context) => CounterBloc()..add(CounterIncEvent()),
      child: BlocBuilder<CounterBloc, int>(builder: (context, state) {
        final bloc = BlocProvider.of<CounterBloc>(context);
        return Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  bloc.add(CounterIncEvent());
                },
                icon: Icon(Icons.plus_one),
              ),
              IconButton(
                onPressed: () {
                  bloc.add(CounterDecEvent());
                },
                icon: Icon(Icons.exposure_minus_1),
              )
            ],
          ),
          body: Center(
            child: Text(
              state.toString(),
              style: TextStyle(fontSize: 33),
            ),
          ),
        );
      }),
    );
  }
}
