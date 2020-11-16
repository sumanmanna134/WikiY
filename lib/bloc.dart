//import 'dart:async';
//
//import 'package:flutterwiki/Model/Model.dart';
//
//import 'Service/Api_Manager.dart';
//
//enum WikiAction {Fetch, Delete}
//
//class ApiBloc{
//
//  final _api_manager = API_Manager();
//  final _stateStreamController = StreamController<List<Pages>>();
//
//  //input Property
//  StreamSink<List<Pages>> get _wikiSink => _stateStreamController.sink;
//  //output Property
//  Stream<List<Pages>> get wikiStream => _stateStreamController.stream;
//
//  final _eventStreamController = StreamController<WikiAction>();
//  StreamSink<WikiAction> get eventSink => _eventStreamController.sink;
//  Stream<WikiAction> get _eventStream => _eventStreamController.stream;
//
//
//  ApiBloc(){
//    _eventStream.listen((event)async {
//      if(event == WikiAction.Fetch)
//      {
//        try {
//          WikiModel news = await _api_manager.getWiki();
//          _wikiSink.add(news.query.pages);
//        } on Exception catch (e) {
//          _wikiSink.addError('Something Went wrong');
//        }
//
//      }
//    });
//  }
//
//
//  void dispose(){
//    _stateStreamController.close();
//    _eventStreamController.close();
//  }
//}