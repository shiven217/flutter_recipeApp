import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/models/recipe_model.dart';
import 'package:recipe/views/recipe_view.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipies = new List();
  String ingridients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Flutter",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: 'Overpass'),
                        ),
                        SizedBox(width: 5.0,),
                        Text(
                          "Recipes",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.pinkAccent,
                              fontFamily: 'Overpass'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Let's cook something interesting today...",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Overpass'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Enter some ingredients i will show you recipes related to it",
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'OverpassRegular'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Overpass'),
                            decoration: InputDecoration(
                              hintText: "Enter Ingredients",
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: 'Overpass'),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                            onTap: () async {
                              if (textEditingController.text.isNotEmpty) {
                                setState(() {
                                  _loading = true;
                                });
                                recipies = new List();
                                String url =
                                    "https://api.edamam.com/search?q=${textEditingController.text}&app_id=6d40a817&app_key=332388f0a96a59bd2e6d584210d867b8";
                                var response = await http.get(url);
                                print(" $response this is response");
                                Map<String, dynamic> jsonData = jsonDecode(response.body);
                                jsonData["hits"].forEach((element) {
                                  RecipeModel recipeModel = new RecipeModel();
                                  recipeModel = RecipeModel.fromMap(element['recipe']);
                                  recipies.add(recipeModel);
                                });
                                setState(() {
                                  _loading = false;
                                });
                              } else {
                                print("error");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      colors: [
                                    const Color(0xffA2834D),
                                    const Color(0xffBC9A5F)
                                  ],
                                      begin: FractionalOffset.topRight,
                                      end: FractionalOffset.bottomLeft)),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    size: 22,
                                      color: Colors.white
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(recipies.length, (index) {
                          return GridTile(
                              child: RecipieTile(
                            title: recipies[index].label,
                            imgUrl: recipies[index].image,
                            desc: recipies[index].source,
                            url: recipies[index].url,
                          ));
                        })),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));

          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

