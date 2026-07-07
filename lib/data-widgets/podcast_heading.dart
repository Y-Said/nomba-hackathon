import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';

class PodcastHeading extends StatefulWidget {
  Map<String, dynamic> data;
  Stream<dynamic> clientStream;
  Sink clientSink;
  bool isPlaying;

  PodcastHeading({
    required this.isPlaying,
    required this.data,
    required this.clientSink,
    required this.clientStream,
  });
  @override
  State<PodcastHeading> createState() => _PodcastHeadingState();
}

class _PodcastHeadingState extends State<PodcastHeading> {
  late Map<String, dynamic> data;
  // Check this podcast is playing or not
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    // If another is playing stop this one and update the state to indicate pausing.
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isPlaying);
    print("HERE WHAT HAPPENS?");
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    // init color to the  color of first heading Podcast
    var color = jsonDecode(data["bgColor"]);
    var r = color[0];
    var g = color[1];
    var b = color[2];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Color.fromRGBO(r, g, b, 1),
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Image.network(
              "https://nomba-hackathon-backend.onrender.com/static/${widget.data["thumb_nail"]}",
              fit: BoxFit.cover,
              width: 180,
              height: 207,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "images/circle-plus.png",
                        width: 22,
                        height: 22,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(39, 48, 55, 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),

                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          "Featured",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    data["name"],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    data["author"],
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(200, 200, 200, 1),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.isPlaying = !widget.isPlaying;

                          if (widget.isPlaying) {
                            widget.clientSink.add(["play", data]);
                          } else if (!widget.isPlaying) {
                            widget.clientSink.add("pause");
                          }
                        });
                      },
                      icon: Icon(
                        widget.isPlaying
                            ? Icons.pause_circle_filled_outlined
                            : Icons.play_circle_filled_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        isPlaying ? "Pause" : "Play Online",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(83, 83, 123, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
