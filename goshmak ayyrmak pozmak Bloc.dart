// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

// Events
abstract class ListEvent {}

class AddItem extends ListEvent {
  final String item;
  AddItem(this.item);
}

class RemoveItem extends ListEvent {
  final int index;
  RemoveItem(this.index);
}

class LoadItems extends ListEvent {}

// States
abstract class ListState {}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded extends ListState {
  final List<String> items;
  ListLoaded(this.items);
}

// Bloc
class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ListState> emit) async {
    emit(ListLoading());
    await Future.delayed(Duration(seconds: 2)); // Fake API call
    emit(ListLoaded(["Item 1", "Item 2", "Item 3"]));
  }

  void _onAddItem(AddItem event, Emitter<ListState> emit) {
    if (state is ListLoaded) {
      final items = List<String>.from((state as ListLoaded).items)
        ..add(event.item);
      emit(ListLoaded(items));
    }
  }

  void _onRemoveItem(RemoveItem event, Emitter<ListState> emit) {
    if (state is ListLoaded) {
      final items = List<String>.from((state as ListLoaded).items);
      if (event.index >= 0 && event.index < items.length) {
        items.removeAt(event.index);
        emit(ListLoaded(items));
      }
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBloc()..add(LoadItems()),
      child: MaterialApp(home: ListPage()),
    );
  }
}

class ListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced BLoC Example')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ListBloc, ListState>(
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
                              () => context.read<ListBloc>().add(
                                RemoveItem(index),
                              ),
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
                      context.read<ListBloc>().add(AddItem(_controller.text));
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
