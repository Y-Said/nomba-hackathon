import 'package:flutter/material.dart';
import 'package:podcast/widgets/util.dart';

class Podcast1 extends StatefulWidget {
  Map<String, dynamic> data;
  Podcast1({required this.data});

  @override
  State<Podcast1> createState() => _Podcast1State();
}

class _Podcast1State extends State<Podcast1> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 148,
      height: 175,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration:BoxDecoration(
          color: Color.fromRGBO(17, 38, 39, 1),
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Column(
          children: [
            Image.network(
              "https://nomba-hackathon-backend.onrender.com/static/${widget.data["thumb_nail"]}",
              width: 148,
              height: 100,
            ),
            Container(
              color: Color.fromRGBO(17, 38, 39, 1),
              padding: EdgeInsets.all(4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 6,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      splitLongText(widget.data["name"]),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.data["author"],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                    Image.asset(
                      "images/circle-plus.png",
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
