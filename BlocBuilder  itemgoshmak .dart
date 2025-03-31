// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Eventler
abstract class ListEvent {}

class AddItem extends ListEvent {
  final String item;
  AddItem(this.item);
}

class RemoveItem extends ListEvent {
  final int index;
  RemoveItem(this.index);
}

// States
abstract class ListState {}

class ListInitial extends ListState {}

class ListLoaded extends ListState {
  final List<String> items;
  ListLoaded(this.items);
}

// BLoC
class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    // Event handler-ler
    on<AddItem>((event, emit) {
      if (state is ListLoaded) {
        final updatedItems = List<String>.from((state as ListLoaded).items)
          ..add(event.item);
        emit(ListLoaded(updatedItems));
      } else {
        emit(ListLoaded([event.item]));
      }
    });

    on<RemoveItem>((event, emit) {
      if (state is ListLoaded) {
        final updatedItems = List<String>.from((state as ListLoaded).items);
        updatedItems.removeAt(event.index);
        emit(ListLoaded(updatedItems));
      }
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListBloc(),
      child: MaterialApp(home: ListPage()),
    );
  }
}

class ListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BlocBuilder with List')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ListBloc, ListState>(
              builder: (context, state) {
                if (state is ListInitial) {
                  return Center(child: Text('Press Add to add an item.'));
                } else if (state is ListLoaded) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.items[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<ListBloc>().add(RemoveItem(index));
                          },
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
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
                      // ListBloc-a yeni element goşmak
                      context.read<ListBloc>().add(AddItem(_controller.text));
                      _controller.clear(); // Input alanını boşaltmak
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
