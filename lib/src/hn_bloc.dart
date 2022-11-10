import 'dart:async';
import 'dart:collection';

import 'package:hn_app/src/article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  List<int> _ids = [
    17392995,
    17397852,
    17395342,
    17385291,
    17387851,
    17395675,
    17387438,
    17393560,
    17391971,
    17392455,
  ];

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  HackerNewsBloc() {
    _updateArticles().then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }


  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  Future<Null> _updateArticles() async {
    final futureArticles = _ids.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }



}