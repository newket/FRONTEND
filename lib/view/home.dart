import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/secure/token_storage.dart';
import 'package:newket/repository/user_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  late UserRepository userRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository(SecureStorage(storage: const FlutterSecureStorage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<String>(
                    future: userRepository.getUserApi(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("");
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data!);
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                ]
            )
        )
    );
  }
}
