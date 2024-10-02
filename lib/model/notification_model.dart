class ConcertIds{
  List<int> concertIds;

  ConcertIds(this.concertIds);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"concertIds": concertIds};
  }
}