class Crypto {
  int rank;
  String symbol;
  String name;
  double supply;
  double priceUsd;
  double changePercent24Hr;
  double volumeUsd24Hr;

  Crypto(
    this.rank,
    this.symbol,
    this.name,
    this.supply,
    this.priceUsd,
    this.changePercent24Hr,
    this.volumeUsd24Hr,
  );

  factory Crypto.fromJsonMap(Map<String, dynamic> jsonMapObject) {
    return Crypto(
      int.parse(jsonMapObject['rank']),
      jsonMapObject['symbol'],
      jsonMapObject['name'],
      double.parse(jsonMapObject['supply']),
      double.parse(jsonMapObject['priceUsd']),
      double.parse(jsonMapObject['changePercent24Hr']),
      double.parse(jsonMapObject['volumeUsd24Hr']),
    );
  }
}
