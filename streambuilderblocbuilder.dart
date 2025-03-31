// streambuilderblocbuilder.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String category;
  AddCategory(this.category);
}

// States
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  CategoryLoaded(this.categories);
}

// BLoC
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<AddCategory>((event, emit) {
      if (state is CategoryLoaded) {
        final updatedCategories = List<String>.from(
          (state as CategoryLoaded).categories,
        )..add(event.category);
        emit(CategoryLoaded(updatedCategories));
      } else {
        emit(CategoryLoaded([event.category]));
      }
    });
  }
}

// StreamController for StreamBuilder example
class CategoryStreamController {
  final _controller = StreamController<String>();
  Stream<String> get stream => _controller.stream;
  void addCategory(String category) {
    _controller.add(category);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryBloc(),
      child: MaterialApp(home: CategoryPage()),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final CategoryStreamController categoryStreamController =
      CategoryStreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Category Manager')),
      body: Column(
        children: [
          // StreamBuilder Example: Listens to the Stream and updates UI when data changes
          StreamBuilder<String>(
            stream: categoryStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Stream received: ${snapshot.data}'),
                );
              } else {
                return Center(child: Text('Stream is empty'));
              }
            },
          ),

          // BlocBuilder Example: Listens to the state of the CategoryBloc
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryInitial) {
                  return Center(child: Text('Press Add to add a category.'));
                } else if (state is CategoryLoaded) {
                  return ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(state.categories[index]));
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
                    decoration: InputDecoration(labelText: 'Enter category'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<CategoryBloc>().add(
                        AddCategory(_controller.text),
                      );
                      categoryStreamController.addCategory(_controller.text);
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
