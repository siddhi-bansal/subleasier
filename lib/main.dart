import 'package:flutter/material.dart';
import 'sublessor/posting_form.dart';
import 'sublessee/postings_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subleasier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Subleasier'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SublessorForm()),
                );
              },
              child: const Column(
                children: [
                  Text(
                    'I\'m a Sublessor',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0)
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Looking for a Subtenant',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostingsBoard()),
                );
              },
              child: const Column(
                children: [
                  Text(
                    'I\'m a Sublessee',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0)
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Looking for an Apartment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}