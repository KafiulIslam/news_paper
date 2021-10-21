import 'package:flutter/material.dart';
import 'package:news_paper/view/article_view.dart';

class BlogTile extends StatelessWidget {
  final String image, title, desc, url;
  BlogTile(
      {@required this.image,
      @required this.title,
      @required this.desc,
      @required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(image)),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
