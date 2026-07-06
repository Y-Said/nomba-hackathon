import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import "package:just_audio/just_audio.dart";
import 'package:podcast/data/test_data.dart';
import 'package:podcast/widgets/mini_player.dart';
import 'package:podcast/widgets/podcast_list.dart';
import 'package:audio_session/audio_session.dart';

// Main Application entry holding a streaming service for playing podcast across screens.
class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  // Ports for interacting with the streaming server.
  late Stream<dynamic> clientStream;
  late Sink serverSink;
  late Sink clientSink;
  late StreamController serverStream;
  var isPlaying = false;
  late AudioPlayer player;
  // Screen used for routing
  var screen = "Discover";
  // displayed Widget
  late Widget TargetWidget;
  Map<String, dynamic> playedSongData = {};


  void switchScreen(String name) {
    switch (name) {
      case "Discover":
        TargetWidget = PodcastList(
          clientSink: clientSink,
          clientStream: clientStream,
        );
        screen = "Discover";
        break;

      case "Podcasts":
        TargetWidget = Text("PodCast List");
        screen = "Podcasts";
        break;

      case "Playlist":
        TargetWidget = Text("Playlist");
        screen = "Playlist";
        break;

      case "Profile":
        TargetWidget = Text("Profile");
        screen = "Profile";
        break;
    }
  }

  // Init Streaming online or local podcast service.
  Future<void> initService() async {
    var isPlaying = false;
    var showPlayer = false; 
    serverStream = StreamController();
    var clientStreamC = StreamController();
    clientStream = clientStreamC.stream.asBroadcastStream();
    
    clientSink = serverStream.sink;
    serverSink = clientStreamC.sink;

    player = AudioPlayer();
    
    
    Timer.periodic(Duration(seconds:1), (timer) {
      serverSink.add([player.playing,playedSongData,"regular",showPlayer]);
    });
      // Listen to screens request
    serverStream.stream.listen((data) {
    
        if (data is List && data.contains("play")) {
          // Check if player already is playing
          if (player.playing) {
            player.stop();
          }

          var url = data[1]["url"];
          player.setAsset(url);
          playedSongData = data[1];
          serverSink.add("isPlaying");
          player.play();
          setState(() {
            isPlaying = true;
            showPlayer = true;
          } );
        }
        // Stop player
        if (data is String && data == "stop") {
          player.stop();
          setState(() {
            showPlayer = false;
            isPlaying = false;
          });
        }
        // Pause player
        if ((data is String) && (data == "pause")) {
          player.pause();
          setState(() {
            showPlayer = true;
            isPlaying  = false;
          });

        }

        if (data == "continue") {
          setState(() {
            player.play();
            isPlaying = player.playing;
          });
        }
        // Get Player Position
        if (data is String && data == "position") {
          serverSink.add(player.position);
        }

        // Seek Player Position
        if (data is List && data.contains("position")) {
          var position = data[1];
          player.seek(position);
        }

        // Is Playing
        if (data is bool && data == true) {
          serverSink.add(player.playing);
        }

        if (data is String && data == "get-song-data") {
          serverSink.add(playedSongData);
        }

        if (data is List && data.contains("player-info")) {
          setState(()  {
            showPlayer = data[0];
            isPlaying = data[1];  
          });
        }
      });
    }

  



  @override
  void initState() {
    super.initState();
    initService();
    TargetWidget = PodcastList(
      clientSink: clientSink,
      clientStream: clientStream,
    );

  }

  @override
  Widget build(BuildContext context) {
    var column = InkWell(
      onTap: () {
        setState(() => switchScreen("Discover"));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: screen == "Discover"
              ? Border.all(color: Color.fromRGBO(0, 138, 255, 1), width: 2)
              : Border.all(style: BorderStyle.none, width: 0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          spacing: 4,
          children: [
            Icon(Icons.search, size: 22, color: Color.fromRGBO(73, 73, 113, 1)),
            Text(
              "Discover",
              style: TextStyle(
                color: Color.fromRGBO(43, 43, 80, 1),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    var column2 = InkWell(
      onTap: () {
        setState(() => switchScreen("Podcasts"));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: screen == "Podcasts"
              ? Border.all(color: Color.fromRGBO(0, 138, 255, 1), width: 2)
              : Border.all(style: BorderStyle.none, width: 0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          spacing: 4,
          children: [
            Icon(
              Icons.my_library_music_rounded,
              size: 22,
              color: Color.fromRGBO(73, 73, 113, 1),
            ),
            Text(
              "Podcasts",
              style: TextStyle(
                color: Color.fromRGBO(43, 43, 80, 1),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    var column3 = InkWell(
      onTap: () {
        setState(() => switchScreen("Playlist"));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: screen == "Playlist"
              ? Border.all(color: Color.fromRGBO(0, 138, 255, 1), width: 2)
              : Border.all(style: BorderStyle.none, width: 0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Icon(
              Icons.queue_music_outlined,
              size: 22,
              color: Color.fromRGBO(73, 73, 113, 1),
            ),
            Text(
              "Playlist",
              style: TextStyle(
                color: Color.fromRGBO(43, 43, 80, 1),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    var column4 = InkWell(
      onTap: () {
        setState(() => switchScreen("Profile"));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: screen == "Profile"
              ? Border.all(color: Color.fromRGBO(0, 138, 255, 1), width: 2)
              : Border.all(style: BorderStyle.none, width: 0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          spacing: 4,
          children: [
            Icon(Icons.person, size: 22, color: Color.fromRGBO(73, 73, 113, 1)),
            Text(
              "Profile",
              style: TextStyle(
                color: Color.fromRGBO(43, 43, 80, 1),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );

    var nav = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [column, column2, column3, column4],
          ),
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        body: TargetWidget,
        persistentFooterButtons: [nav],
        persistentFooterDecoration: BoxDecoration(
          color: Color.fromRGBO(73, 73, 113, 1),
        ),
      ),
    );
  }
}
