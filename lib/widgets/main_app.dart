import 'dart:isolate';

import 'package:flutter/material.dart';
import "package:just_audio/just_audio.dart";
import 'package:podcast/data/test_data.dart';
import 'package:podcast/widgets/podcast_list.dart';

// Main Application entry holding a streaming service for playing podcast across screens.
class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  // Ports for interacting with the streaming server.
  late ReceivePort serverRecvPort;
  late Stream<dynamic> clientRecvPort;
  late SendPort clientSendPort;
  late SendPort serverSendPort;

  late Map<String, dynamic> data;
  late Future<bool> loadingStatus;
  late AnimationController animationController;
  late Animation<double> animation;
  var alpha = 0.0;

  // Main Streaming service run in different thread
  Future<void> streamingService(dynamic channels) async {
    var recvPort = channels[0] as ReceivePort;
    var sendPort = channels[1] as SendPort;

    var player = AudioPlayer();
    // Listen to screens request
    recvPort.listen((data) {
      if (data is List && data.contains("play")) {
        // Check if player already is playing
        if (player.playing) {
          player.stop();
        }

        var url = data[1];
        player.setUrl(url);
        player.play();
      }
      // Stop player
      if (data is String && data == "stop") {
        player.stop();
      }
      // Pause player
      if (data is String && data == "pause") {
        player.pause();
      }
      // Get Player Position
      if (data is String && data == "position") {
        sendPort.send(player.position);
      }

      // Seek Player Position
      if (data is List && data.contains("position")) {
        var position = data[1];
        player.seek(position);
      }

      // Is Playing
      if (data is bool && data == true) {
        sendPort.send(player.playing);
      }
    });
  }

  // Init Streaming online or local podcast service.
  Future<void> initService() async {
    serverRecvPort = ReceivePort();
    var clientRecv = ReceivePort();

    clientSendPort = serverRecvPort.sendPort;
    serverSendPort = clientRecv.sendPort;
    // We mark as broadcast stream as many screens will subscribe to the service.
    clientRecvPort = clientRecv.asBroadcastStream();

    await Isolate.spawn(streamingService, [serverRecvPort, serverSendPort]);
  }

  Future<bool> isLoaded() async {
    await Future.delayed(Duration(seconds: 6));
    var testData = TestData();
    testData.init();
    data = testData.data;
    return true;
  }

  @override
  void initState() {
    super.initState();
    initService();
    loadingStatus = isLoaded();

    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.2, end: 1).animate(animationController);
    animationController.forward();

    animationController.addListener(() {
      setState(() {
        alpha = animation.value;
      });
      if (animationController.isCompleted) {
        animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: loadingStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PodcastList(data: data);
        }
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Container(
                width: width,
                height: 200,
                child: Text(""),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(73, 73, 113, alpha),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Container(
                    width: 180,
                    height: 32,
                    margin: EdgeInsets.only(left: 8),
                    color: Color.fromRGBO(73, 73, 113, alpha),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Container(
                    width: 180,
                    height: 32,
                    margin: EdgeInsets.only(left: 8),
                    color: Color.fromRGBO(73, 73, 113, alpha),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 73, 113, alpha),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(83, 83, 123, 0.5),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(83, 83, 123, 0.5),
            title: Expanded(
              child: Container(
                height: 32,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(73, 73, 113, 0.9),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
