import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MiniPlayer extends StatefulWidget {
  Sink clientSink;
  Stream<dynamic> clientStream;
  MiniPlayer({required this.clientStream, required this.clientSink});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool isPlaying = false;
  late String playedSong;
  late String author;
  var time = "";
  var thumb_nail = "";
   late StreamSubscription subscription;
 
  @override
  void initState() {
    super.initState();

    subscription = widget.clientStream.listen(processPlayerResponse);

    widget.clientSink.add("get-song-data");
  }

  void processPlayerResponse(data) {
    if (data is Map) {
      playedSong = data["name"];
      author = data["author"];
      thumb_nail = data['thumb_nail'];
      setState(() => isPlaying = true);
    }

    if (data is List && data.contains("regular")) {
      print("$data MIni Game");
      var podcast = data[1];
      if (data[0]) {
        setState(() => isPlaying = true);
      } else {
        setState(() => isPlaying = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  Widget build(Object context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Color.fromRGBO(43, 43, 83, 1),
        child: Column(
          spacing: 16,
          children: [
            Container(
              padding: EdgeInsets.all(4.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mini Player",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(43, 43, 80, 1),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.clientSink.add("stop");
                    },
                    icon: Icon(
                      Icons.close,
                      size: 22,
                      color: Color.fromRGBO(43, 43, 43, 1),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  thumb_nail,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Text(
                  playedSong,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(
                    color: Color.fromRGBO(200, 200, 200, 1),
                    fontSize: 16,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        //this.widget.togglePlayer();
                        widget.clientSink.add("pause");
                      } else {
                        widget.clientSink.add("continue");
                      }
                    });
                  },
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_outlined
                        : Icons.play_circle_fill_outlined,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
