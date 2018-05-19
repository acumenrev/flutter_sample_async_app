import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.thumbnailUrl});

  factory Photo.fromJSON(Map<String, dynamic> json) {
    return Photo(id: json['id'] as int,
    title: json['title'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String);
  }

}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final String url = 'https://jsonplaceholder.typicode.com/photos';
  final response = await client.get(url);
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String response) {
  final parsed = json.decode(response).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => new Photo.fromJSON(json)).toList();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(appBar: new AppBar(
      title: new Text(title),
    ),
    body: new FutureBuilder<List<Photo>>(future: fetchPhotos(new http.Client()),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);

      return snapshot.hasData ? new PhotoList(photos: snapshot.data) : new Center(child: new CircularProgressIndicator());
    },));
  }
}

class PhotoList extends StatelessWidget {
  final List<Photo> photos;

  PhotoList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GridView.builder(gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (context, index) {
      return new Image.network(photos[index].thumbnailUrl);
    },
    itemCount: photos.length,);
  }
}