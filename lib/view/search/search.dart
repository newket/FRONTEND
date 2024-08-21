import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Search(),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => _Search();
}

class _Search extends State<Search> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
