import 'package:flutter/material.dart';

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
      height: 133,
      child: Column(
        children: [
          Image.asset(widget.data["thumb_nail"], width: 148, height: 100),
          Container(
            color: Color.fromRGBO(17, 38, 39, 1),
            padding: EdgeInsets.all(4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing:6,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data["name"],
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
                  Image.asset("images/circle-plus.png", width: 16, height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
