import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe/models/hits.dart';

class Recipe {
  List<Hits> hits = [];

  Future<void> getReceipe() async {
    String url =
        "https://api.edamam.com/search?q=banana&app_id=0f21d949&app_key=332388f0a96a59bd2e6d584210d867b8";
    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      Hits hits = Hits(
        recipeModel: element['recipe'],
      );
    });
  }
}
