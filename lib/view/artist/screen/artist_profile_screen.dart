import 'package:flutter/material.dart';

class ArtistProfileScreen extends StatefulWidget {
  final int artistId;

  const ArtistProfileScreen({super.key, required this.artistId});

  @override
  State<StatefulWidget> createState() => _ArtistProfileScreen();
}

class _ArtistProfileScreen extends State<ArtistProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
