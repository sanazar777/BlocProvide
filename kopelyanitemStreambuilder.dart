// main.dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StreamListExample());
  }
}

class StreamListExample extends StatefulWidget {
  @override
  _StreamListExampleState createState() => _StreamListExampleState();
}

class _StreamListExampleState extends State<StreamListExample> {
  // StreamController: Maglumat akymyny geçirip bilmek üçin
  final StreamController<List<String>> _listController =
      StreamController<List<String>>();
  List<String> _data = [];

  @override
  void initState() {
    super.initState();
    // Streami başlatmak
    _startAddingData();
  }

  // Stream-de maglumat goşulýan funksiýa
  void _startAddingData() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _data.add('Item ${_data.length + 1}');
      _listController.sink.add(
        List.from(_data),
      ); // Stream'e täze maglumat goşulýar
    });
  }

  @override
  void dispose() {
    // StreamController-i ýapmak
    _listController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StreamBuilder List Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<String>>(
          stream: _listController.stream, // Stream akymy
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              ); // Maglumatlar alýança
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              ); // Hata bar bolsa
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available')); // Maglumat ýok
            } else {
              // Stream-den gelen maglumatlary görkezmek
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(snapshot.data![index]));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
