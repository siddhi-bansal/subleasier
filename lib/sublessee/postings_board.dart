import 'package:flutter/material.dart';

class PostingsBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postings Board'),
      ),
      body: const Center(
        child: Text(
          'Postings Board',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}