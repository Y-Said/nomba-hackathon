import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:podcast/data-widgets/play_inside.dart";
import "package:podcast/data-widgets/playlist_item.dart";
import "package:podcast/widgets/mini_player.dart";
import "package:uuid/uuid.dart";

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
  late Map<String, dynamic> data;
  var controller = TextEditingController();
  late Future<bool> loadingPlaylist;
  var verified = false;
  var selectedPlaylist = <String>[];

  Future<void> createPlaylist(String playlist) async {
    var root = await getApplicationDocumentsDirectory();
    var rootPath = root.path;

    var playlistFile = "playlist.json";
    var playOpenedFile = File("$rootPath/$playlistFile");

    var exists = await playOpenedFile.exists();
    if (!exists) {
      await playOpenedFile.create();
      Map<String, dynamic> data = {};
      var uniquId = Uuid();
      data[playlist] = [playlist, uniquId.v4(), []];
      playOpenedFile.writeAsString(jsonEncode(data));
    } else {
      var data = await playOpenedFile.readAsString();
      var jsonData = jsonDecode(data);
      var uniquId = Uuid();
      jsonData[playlist] = [playlist, uniquId.v4(), []];
      playOpenedFile.writeAsString(jsonEncode(jsonData));
    }
    var data = await playOpenedFile.readAsString();
    var decodedData = jsonDecode(data);
    this.data = decodedData;
    reload();
  }

  void reload() {
    setState(() => print("reloading state"));
  }

  void setSelectedPlaylist(String uniqueId) {
    if (selectedPlaylist.contains(uniqueId)) {
      selectedPlaylist.remove(uniqueId);
    } else {
      selectedPlaylist.add(uniqueId);
    }

    setState(() {
      print("Reloading State $selectedPlaylist");
    });
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
      print(jsonData.runtimeType);
      this.data = jsonData;
    }

    return true;
  }

  Future<void> deletePlaylist() async {
    var root = await getApplicationDocumentsDirectory();
    var rootPath = root.path;

    var playlistFile = "playlist.json";
    var playOpenedFile = File("$rootPath/$playlistFile");

    for (var item in selectedPlaylist) {
      data.remove(item);
    }

    await playOpenedFile.writeAsString(jsonEncode(data));
    setState(() {
      selectedPlaylist = [];
    });
  }

  @override
  void initState() {
    super.initState();
    loadingPlaylist = openedPlaylist();
    widget.clientStream.listen((dat) {
      if (dat is List && dat.contains("regular")) {
        var podcast = dat[1];
        setState(() {
          playedPodcast = podcast;
          isPlaying = dat[0];
          showPlayer = dat.last;
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
                    showDialog(context: context, builder: createPlaylistDialog);
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

                  onPressed: () {
                    showDialog(context: context, builder: createPlaylistDialog);
                  },
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
      ],
    );

    var unsubscribedUser = Container(
      width: width,
      height: height,
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
        if (asyncSnapshot.hasData && data.isNotEmpty) {
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
                  height: height - 85,
                  padding: EdgeInsets.all(8.0),
                  color: Color.fromRGBO(83, 83, 113, 1),
                  child: Column(
                    spacing: 16,
                    children: [
                      SafeArea(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: selectedPlaylist.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedPlaylist = [];
                                        });
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          deletePlaylist();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          builder: createPlaylistDialog,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            for (var playlist in data.keys)
                              PlaylistItem(
                                isSelected: selectedPlaylist.contains(
                                  data[playlist]?[0] as String,
                                ),
                                setSelectedPlaylist: setSelectedPlaylist,
                                data: {
                                  "name": data[playlist]?[0],
                                  "uniqueId": data[playlist]?[1],
                                  "episodes": data[playlist]?[2],
                                },
                              ),
                          ],
                        ),
                      ),
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

  Widget createPlaylistDialog(context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(83, 83, 123, 1),
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
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 22, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      content: Container(
        height: 70,
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),

                    borderSide: BorderSide(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),

                    borderSide: BorderSide(
                      color: Color.fromRGBO(230, 230, 230, 1),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: "Enter Playlist Name?",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(200, 200, 200, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 8.0, horizontal: 64),
            ),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            backgroundColor: WidgetStatePropertyAll<Color>(
              Color.fromRGBO(0, 138, 255, 1),
            ),
          ),
          onPressed: () {
            if (controller.text.trim() != "") {
              print("updating state");
              createPlaylist(controller.text);
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Create",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
