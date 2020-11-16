import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterwiki/Model/Model.dart';
import 'package:flutterwiki/Service/Api_Manager.dart';
import 'package:flutterwiki/View/webview.dart';
import 'package:flutterwiki/bloc.dart';
import 'package:flutterwiki/utils/Constant.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box box;
  List data = [];
  Future wikidata;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search ' );
  TextEditingController searchController=new TextEditingController();
  Future<bool> getWiki({String keyWord}) async{
    await openBox();
    String Url = Constants.Api + keyWord;
    print(Url);

    try{
      var response = await http.get(Url);
      if(response.statusCode == 200){
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        print(jsonMap['query']['pages']);
        await putData(jsonMap['query']['pages']);
      }
    }on SocketException{
      print("no internet");
    }
    var wikimap = box.toMap().values.toList();
    if(wikimap.isEmpty){
      data.add("empty");

    }else{
      data = wikimap;
    }

    return Future.value(true);

  }


  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future putData(data) async{
    await box.clear();
    for(var d in data){
      box.add(d);
    }
  }

  void _searchPressed(){

    setState(() {
      if(this._searchIcon.icon == Icons.search){
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: searchController,
          cursorColor: Colors.white70,
          decoration:  InputDecoration(
            fillColor: Colors.white70,

            hintText: "Search",
          ),

        );

      }else{

        this._appBarTitle = new Text('Search');
        this._searchIcon = new Icon(Icons.search);
        searchController.clear();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wikidata = getWiki(keyWord: 'google');
    searchController.addListener(() {
      setState(() {

        wikidata = getWiki(keyWord: searchController.text);
      });
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: _appBarTitle,
        leading: IconButton(icon: this._searchIcon, onPressed: (){
          _searchPressed();
        }),
      ),
      body: Container(

        child: FutureBuilder(
          future: wikidata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot);
              if(data.contains("empty")){
                return Center(child: Text("No Data"),);
              }else{
                return ListView.builder(
                    itemCount: data.length,

                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 10,left: 9, right: 9),
                          height: 70,
                          child: Row(
                            children: <Widget>[
                              Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: FittedBox(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => CircularProgressIndicator(),

                                        imageUrl:data[index]["thumbnail"]==null?"https://img2.pngio.com/index-of-areaedu-wp-content-uploads-2016-02-default-png-600_600.png":data[index]["thumbnail"]["source"],
                                        height: 50,
                                        width: 50,

                                      ),
                                    )),
                              ),
                              SizedBox(width: 16),
                            Flexible(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data[index]['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      data[index]['terms']==null?"No Decription":data[index]['terms']['description'][0],
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ],
                          ),
                        ),
                        onTap: (){
                          print(data[index]['title']);
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => WebViewPage(title: data[index]['title'],)),);
                        },
                      );
                    });
              }
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
