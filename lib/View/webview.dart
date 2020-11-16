import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwiki/utils/Constant.dart';
import 'package:flutterwiki/utils/menu.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewPage extends StatefulWidget {
  final String title;

  const WebViewPage({Key key, this.title}) : super(key: key);
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  final Set<String> _favorites = Set<String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [

        Menu(_controller.future, () => _favorites),
      ],),
      body:WebView(
        initialUrl: Constants.SearchTopicApi+widget.title,
        onWebViewCreated: (WebViewController webViewController){
          _controller.complete(webViewController);
        },

      ),

      floatingActionButton: _bookMarkButton(),

    );
  }
  _bookMarkButton(){
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context,  AsyncSnapshot<WebViewController> controller){
        if(controller.hasData){
          return FloatingActionButton(
            onPressed: ()async{
              var url = await controller.data.currentUrl();
              _favorites.add(url);
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Saved $url for later reading.')),
              );
            },
            child: Icon(Icons.favorite),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
