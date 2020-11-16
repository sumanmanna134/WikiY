// To parse this JSON data, do
//
//     final wikiModel = wikiModelFromJson(jsonString);

import 'dart:convert';

WikiModel wikiModelFromJson(String str) => WikiModel.fromJson(json.decode(str));

String wikiModelToJson(WikiModel data) => json.encode(data.toJson());

class WikiModel {
  WikiModel({
    this.batchcomplete,
    this.wikiModelContinue,
    this.query,
  });

  bool batchcomplete;
  Continue wikiModelContinue;
  Query query;

  factory WikiModel.fromJson(Map<String, dynamic> json) => WikiModel(
    batchcomplete: json["batchcomplete"],
    wikiModelContinue: Continue.fromJson(json["continue"]),
    query: Query.fromJson(json["query"]),
  );

  Map<String, dynamic> toJson() => {
    "batchcomplete": batchcomplete,
    "continue": wikiModelContinue.toJson(),
    "query": query.toJson(),
  };
}

class Query {
  Query({
    this.pages,
  });

  List<Pages> pages;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    pages: List<Pages>.from(json["pages"].map((x) => Pages.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages": List<dynamic>.from(pages.map((x) => x.toJson())),
  };
}

class Pages {
  Pages({
    this.pageid,
    this.ns,
    this.title,
    this.index,
    this.thumbnail,
    this.terms,
  });

  int pageid;
  int ns;
  String title;
  int index;
  Thumbnail thumbnail;
  Terms terms;

  factory Pages.fromJson(Map<String, dynamic> json) => Pages(
    pageid: json["pageid"],
    ns: json["ns"],
    title: json["title"],
    index: json["index"],
    thumbnail: Thumbnail.fromJson(json["thumbnail"]),
    terms: Terms.fromJson(json["terms"]),
  );

  Map<String, dynamic> toJson() => {
    "pageid": pageid,
    "ns": ns,
    "title": title,
    "index": index,
    "thumbnail": thumbnail.toJson(),
    "terms": terms.toJson(),
  };
}

class Terms {
  Terms({
    this.description,
  });

  List<String> description;

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
    description: List<String>.from(json["description"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": List<dynamic>.from(description.map((x) => x)),
  };
}

class Thumbnail {
  Thumbnail({
    this.source,
    this.width,
    this.height,
  });

  String source;
  int width;
  int height;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
    source: json["source"]==null?"k":json["source"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "source": source==null?"true":"k",
    "width": width,
    "height": height,
  };
}

class Continue {
  Continue({
    this.gpsoffset,
    this.continueContinue,
  });

  int gpsoffset;
  String continueContinue;

  factory Continue.fromJson(Map<String, dynamic> json) => Continue(
    gpsoffset: json["gpsoffset"],
    continueContinue: json["continue"],
  );

  Map<String, dynamic> toJson() => {
    "gpsoffset": gpsoffset,
    "continue": continueContinue,
  };
}
