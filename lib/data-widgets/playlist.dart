import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:podcast/data-widgets/play_inside.dart";
import "package:podcast/data-widgets/playlist_item.dart";
import "package:podcast/widgets/mini_player.dart";

class Playlist extends StatefulWidget {
  Sink clientSink;
  Stream<dynamic> clientStream;
  void Function() gotoSubscribe;

  Playlist({
    required this.clientSink,
    required this.clientStream,
    required this.gotoSubscribe,
  });
  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  late StreamSubscription subscription;
  Map<String, dynamic> playedPodcast = {};
  var isPlaying = false;
  var showPlayer = false;
  late Map<String, List<String>> data;
  var controller = TextEditingController();
  late Future<bool> loadingPlaylist;
  var verified = false;

  Future<void> createPlaylist(String playlist) async {
    var root = await getApplicationDocumentsDirectory();
    var rootPath = root.path;

    var playlistFile = "playlist.json";
    var playOpenedFile = File("$rootPath/$playlistFile");

    var exists = await playOpenedFile.exists();
    if (!exists) {
      await playOpenedFile.create();
      Map<String, List<String>> data = {};
      data[playlist] = [];
      playOpenedFile.writeAsString(jsonEncode(data));
    } else {
      var data = await playOpenedFile.readAsString();
      var jsonData = jsonDecode(data);
      jsonData[playlist] = [];
      playOpenedFile.writeAsString(jsonEncode(jsonData));
    }
  }

  Future<void> isUserVerified() async {
    var clientID = "client_ID";
    var root = await getApplicationDocumentsDirectory();
    var rootPath = root.path;
    var file = File("$rootPath/$clientID");

    var data = await file.readAsString();
    var userInfo = jsonDecode(data);

    (() {
      setState(() {
        verified = userInfo["subscribed"] != 0;
      });
    })();
  }

  Future<bool> openedPlaylist() async {
    var root = await getApplicationDocumentsDirectory();
    var rootPath = root.path;

    var playlistFile = "playlist.json";
    var playOpenedFile = File("$rootPath/$playlistFile");

    var exists = await playOpenedFile.exists();

    if (!exists) {
      await playOpenedFile.create();
      data = {};
    } else {
      var data = await playOpenedFile.readAsString();
      var jsonData = jsonDecode(data);
      this.data = jsonData;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    loadingPlaylist = openedPlaylist();
    widget.clientStream.listen((data) {
      if (data is List && data.contains("regular")) {
        var podcast = data[1];
        setState(() {
          playedPodcast = podcast;
          isPlaying = data[0];
          showPlayer = data.last;
        });
      }
    });

    isUserVerified();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    var width = MediaQuery.of(context).size.width;
    var emptyPlayList = Column(
      children: [
        if (showPlayer)
          MiniPlayer(
            clientStream: widget.clientStream,
            clientSink: widget.clientSink,
          ),
        SafeArea(
          child: Container(
            width: width,
            color: Color.fromRGBO(83, 83, 113, 1),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Playlist",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Container(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Create a New Playlist",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                          content: Column(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(8.0),
                                    hintText: "Enter Playlist Name?",
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(43, 43, 80, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            FilledButton(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 64,
                                  ),
                                ),
                                shape:
                                    WidgetStatePropertyAll<
                                      RoundedRectangleBorder
                                    >(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                  Color.fromRGBO(0, 138, 255, 1),
                                ),
                              ),
                              onPressed: () {
                                if (controller.text.trim() != "") {
                                  setState(() {
                                    createPlaylist(controller.text);
                                  });
                                }
                              },
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_circle_outline_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: width,
              padding: EdgeInsets.all(8.0),
              color: Color.fromRGBO(83, 83, 113, 1),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.info_outlined, size: 32, color: Colors.white),
                  Text(
                    "No Playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FilledButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 64),
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Color.fromRGBO(0, 138, 255, 1),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Add Playlist",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    var unsubscribedUser = Container(
      width:width,
      height:height,
      child: Column(
        children: [
          if (showPlayer)
            MiniPlayer(
              clientStream: widget.clientStream,
              clientSink: widget.clientSink,
            ),
          SafeArea(
            child: Container(
              width: width,
              color: Color.fromRGBO(83, 83, 113, 1),
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: width,
                padding: EdgeInsets.all(8.0),
                color: Color.fromRGBO(83, 83, 113, 1),
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outlined, size: 32, color: Colors.white),
                    Text(
                      "Only available in subscription",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 64),
                        ),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Color.fromRGBO(0, 138, 255, 1),
                        ),
                      ),
                      onPressed: () {
                        widget.gotoSubscribe();
                      },
                      child: Text(
                        "Subscribe",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!verified) {
      return unsubscribedUser;
    }
    // TODO: implement build
    return FutureBuilder(
      future: loadingPlaylist,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Column(
            children: [
              if (showPlayer)
                MiniPlayer(
                  clientStream: widget.clientStream,
                  clientSink: widget.clientSink,
                ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: height,
                  padding: EdgeInsets.all(8.0),
                  color: Color.fromRGBO(83, 83, 113, 1),
                  child: Column(
                    spacing: 16,
                    children: [
                      SafeArea(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Playlist",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add_circle_outline_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      for (var i in [3, 3, 3, 3, 4, 3]) PlaylistItem(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return emptyPlayList;
      },
    );
  }
}
