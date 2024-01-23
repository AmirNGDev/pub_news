import 'dart:convert';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

Future<dynamic> rssToJson() async {
  var client = http.Client();
  final MyTransformer = Xml2Json();
  try {
    var response = await client.get(Uri.parse('https://pub.dev/feed.atom'));
    var bodyString = response.body;
    MyTransformer.parse(bodyString);
    var json = MyTransformer.toGData();
    var jsonData = jsonDecode(json);
    return jsonData;
  } catch (e) {
    print(e.toString());
  }
}
