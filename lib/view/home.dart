import 'package:flutter/material.dart';
import 'package:newket/repository/ticket_repository.dart';
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
  late TicketRepository ticketRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    ticketRepository = TicketRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("NEWKET",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                color: Color(0xff5A4EF6),
                fontWeight: FontWeight.w900)),
      ),
      body: FutureBuilder(
        future: ticketRepository.openingNoticeApi(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("데이터 로딩 실패"));
          } else {
            final openingResponse = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // 좌우 여백을 16픽셀로 설정
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("오픈 예정",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16,
                                  color: Color(0xff151515),
                                  fontWeight: FontWeight.bold)),
                          Text("자세히보기 >",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 12,
                                  color: Color(0xff565E6D),
                                  fontWeight: FontWeight.normal))
                        ]),
                    Expanded(
                      child: ListView.builder(
                          itemCount: openingResponse.concert.length,
                          itemBuilder: (context, position) {
                            return GestureDetector(
                              child: Card(
                                  child: Row(children: <Widget>[
                                    Image.network(
                                        openingResponse.concert[position].imageUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain),
                                    Text(openingResponse.concert[position].title)
                                  ])),
                              onTap: () {
                                // Handle onTap
                              },
                            );
                          }),
                    ),
                  ]),
            );
          }
        },
      ),
    );
  }
}
