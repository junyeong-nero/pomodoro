import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key, required this.title});

  final String title;

  @override
  State<EmptyPage> createState() => _EmptyState();
}

class _EmptyState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text("Hello World!"),
        TextButton(
          child: Text("Return to origin page"),
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    ));
  }
}
