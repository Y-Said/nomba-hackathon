import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Podcast extends StatefulWidget {
  Map<String, dynamic> data;
  Podcast({required this.data});

  @override
  State<Podcast> createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  late Color color;

  @override
  void initState() {
    super.initState();
    // init color to the  color of first heading Podcast
    var c = widget.data["bgColor"] as List<int>;
    var r = c[0];
    var g = c[1];
    var b = c[2];

    color = Color.fromRGBO(r, g, b, 1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(8.0),
      width:250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(widget.data["thumb_nail"], width: 135, height: 89),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/circle-plus.png", width: 22, height: 22),
                Text(
                  widget.data["name"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.data["author"],
                  style: TextStyle(
                    color: Color.fromRGBO(230, 230, 230, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
