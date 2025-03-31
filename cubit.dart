// cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

// Cubit State
abstract class ListState {}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded extends ListState {
  final List<String> items;
  ListLoaded(this.items);
}

// Cubit
class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());

  Future<void> loadItems() async {
    emit(ListLoading());
    await Future.delayed(Duration(seconds: 2)); // Fake API call
    emit(ListLoaded(["Item 1", "Item 2", "Item 3"]));
  }

  void addItem(String item) {
    if (state is ListLoaded) {
      final items = List<String>.from((state as ListLoaded).items)..add(item);
      emit(ListLoaded(items));
    }
  }

  void removeItem(int index) {
    if (state is ListLoaded) {
      final items = List<String>.from((state as ListLoaded).items);
      if (index >= 0 && index < items.length) {
        items.removeAt(index);
        emit(ListLoaded(items));
      }
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListCubit()..loadItems(),
      child: MaterialApp(home: ListPage()),
    );
  }
}

class ListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Cubit Example')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ListCubit, ListState>(
              builder: (context, state) {
                if (state is ListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ListLoaded) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.items[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed:
                              () => context.read<ListCubit>().removeItem(index),
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('Press button to load items'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Enter item'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<ListCubit>().addItem(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
