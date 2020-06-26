import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({@required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  String finalUrl ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = widget.postUrl;
    if(widget.postUrl.contains('http://')){
      finalUrl = widget.postUrl.replaceAll("http://","https://");
      print(finalUrl + "this is final url");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:30, right: 24,left: 24,bottom: 16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xff213A50),
                        const Color(0xff071930)
                      ],
                      begin: FractionalOffset.topRight,
                      end: FractionalOffset.bottomLeft)),
              child:  Row(
                mainAxisAlignment:MainAxisAlignment.center,
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
            Container(
              height: MediaQuery.of(context).size.height -80,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                onPageFinished: (val){
                  print(val);
                },
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: finalUrl,
                onWebViewCreated: (WebViewController webViewController){
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
