import 'dart:convert';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

Future<dynamic> rssToJson() async {
  var client = http.Client();
  final MyTransformer = Xml2Json();
  try {
    return await client.get(Uri.parse('https://pub.dev/feed.atom')).then((response) {
      return response.body;
    }).then((bodyString) {
      MyTransformer.parse(bodyString);
      var json = MyTransformer.toGData();
      var jsonData = jsonDecode(json);
      return jsonData;
    });
  }  catch (_) {
    print('Errorrrrrrrrrrrrrrr');
  }
}
