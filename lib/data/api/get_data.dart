import 'package:crypto_v1/data/models/crypto_model.dart';
import 'package:dio/dio.dart';

Future<List<Crypto>> getData() async {
  var response = await Dio().get('https://api.coincap.io/v2/assets');
  List<Crypto> cryptoList = response.data['data']
      .map<Crypto>((jsonMapObject) => Crypto.fromJsonMap(jsonMapObject))
      .toList();
  return cryptoList;
}
