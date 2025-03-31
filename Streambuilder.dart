// main.dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StreamBuilderExample());
  }
}

class StreamBuilderExample extends StatelessWidget {
  // Stream: Maglumatlary yzyna ugradar
  final Stream<List<String>> _dataStream = Stream<List<String>>.periodic(
    Duration(seconds: 3), // her 1 sekuntda maglumatlary yzarla
    (count) {
      if (count % 2 == 0) {
        return ["Item 1", "Item 2", "Item 3"];
      } else {
        return ["Item 4", "Item 5", "Item 6"];
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StreamBuilder Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<String>>(
          stream: _dataStream, // Stream, bu ýerde _dataStream ulanylýar
          builder: (context, snapshot) {
            // Stream-dan gelen ýagdaýy barlaň
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              // Maglumat akymyndan gelen sanawy görkezmek
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
