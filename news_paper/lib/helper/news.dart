import 'dart:convert';
import 'dart:core';
import 'package:news_paper/models/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    try {
      final response = await http.get(Uri.https(
          'newsapi.org',
          '/v2/top-headlines',
          {'country': 'in', 'apiKey': '162b1dbe35114c8ea11eba9870f53680'}));

      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((elements) {
          if (elements["urlToImage"] != null &&
              elements['description'] != null) {
            ArticleModel articlemodel = new ArticleModel(
              title: elements["title"],
              urlToImage: elements["urlToImage"],
              description: elements["description"],
              content: elements["content"],
              author: elements["author"],
              url: elements["url"],
            );
            news.add(articlemodel);
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }
}

class CategoryNewsClass {
  List<ArticleModel> news = [];

  Future<void> getNews(String category) async {
    try {
      final response =
          await http.get(Uri.https('newsapi.org', '/v2/top-headlines', {
        'country': 'in',
        'category': '$category',
        'apiKey': '162b1dbe35114c8ea11eba9870f53680'
      }));

      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((elements) {
          if (elements["urlToImage"] != null &&
              elements['description'] != null) {
            ArticleModel articlemodel = new ArticleModel(
              title: elements["title"],
              urlToImage: elements["urlToImage"],
              description: elements["description"],
              content: elements["content"],
              author: elements["author"],
              url: elements["url"],
            );
            news.add(articlemodel);
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }
}
