// main.dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StreamCounterExample());
  }
}

class StreamCounterExample extends StatefulWidget {
  @override
  _StreamCounterExampleState createState() => _StreamCounterExampleState();
}

class _StreamCounterExampleState extends State<StreamCounterExample> {
  // StreamController: Maglumat akymyny geçirmek üçin ulanylýar
  final StreamController<int> _counterController = StreamController<int>();

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Sanagyň yzarlanmasy
    _startCounter();
  }

  // Sanagyň her sekuntda artmagyny üpjün etmek
  void _startCounter() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _counter++;
      _counterController.sink.add(_counter); // Stream-e maglumat geçirmek
    });
  }

  @override
  void dispose() {
    // StreamController-ı ýapmak
    _counterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StreamBuilder Counter Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream:
                  _counterController
                      .stream, // StreamController-dan alnan stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Maglumatlar alýança
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
                } else {
                  // Stream-den gelen maglumatlary görkezmek
                  return Text(
                    'Counter: ${snapshot.data}',
                    style: TextStyle(fontSize: 30),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _counter = 0; // Sanagy zerurlykdan täzeden başlamaga çalyşýarys
                _counterController.sink.add(_counter);
              },
              child: Text('Reset Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
