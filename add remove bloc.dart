// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Eventler ---
abstract class ItemEvent {}

class AddItem extends ItemEvent {
  final String item;
  AddItem(this.item);
}

class RemoveItem extends ItemEvent {
  final int index;
  RemoveItem(this.index);
}

// --- States ---
abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoaded extends ItemState {
  final List<String> items;
  ItemLoaded(this.items);
}

// --- Bloc ---
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
  }

  // Element goşulanda işleýän funksiýa
  void _onAddItem(AddItem event, Emitter<ItemState> emit) {
    if (state is ItemLoaded) {
      final updatedItems = List<String>.from((state as ItemLoaded).items)
        ..add(event.item);
      emit(ItemLoaded(updatedItems));
    } else {
      emit(ItemLoaded([event.item]));
    }
  }

  // Element aýrylanda işleýän funksiýa
  void _onRemoveItem(RemoveItem event, Emitter<ItemState> emit) {
    if (state is ItemLoaded) {
      final updatedItems = List<String>.from((state as ItemLoaded).items);
      updatedItems.removeAt(event.index);
      emit(ItemLoaded(updatedItems));
    }
  }
}

// --- UI ---
class ItemListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLoC List Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sanawa element goşmak üçin giriş
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Add Item'),
            ),
            SizedBox(height: 10),
            // Goşmak üçin düwme
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context.read<ItemBloc>().add(AddItem(_controller.text));
                  _controller.clear();
                }
              },
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            // Listi görkezmek
            BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemInitial) {
                  return Center(child: Text('No items added.'));
                } else if (state is ItemLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.items[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context.read<ItemBloc>().add(RemoveItem(index));
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemBloc(),
      child: MaterialApp(home: ItemListPage()),
    );
  }
}
