import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:podcast/data-widgets/heading_podcast_list.dart';
import 'package:podcast/data-widgets/pod_sub_list.dart';
import 'package:podcast/data/test_data.dart';
import 'package:podcast/widgets/category.dart';
import 'package:podcast/widgets/mini_player.dart';

// List of Discovered
class PodcastList extends StatefulWidget {
  Sink clientSink;
  Stream<dynamic> clientStream;

  PodcastList({required this.clientSink, required this.clientStream});

  @override
  State<PodcastList> createState() => _PodcastListState();
}

class _PodcastListState extends State<PodcastList>
    with TickerProviderStateMixin {
  late StreamSubscription subscription;
  late Map<String, dynamic> data;
  Map<String, dynamic> targetData = {};
  late Future<bool> loadingStatus;
  late AnimationController animationController;
  late Animation<double> animation;
  var alpha = 0.0;
  var isSearching = false;
  List<dynamic> searchedItems = [];
  var textController = TextEditingController();
  var category = "All Category";
  var showPlayer = false;

  void searchPodcast(String text) {
    for (var item in data.keys.toList()) {
      for (var podcast in data[item]) {
        if (podcast["name"].contains(text)) {
          searchedItems.add(podcast);
        }
      }
    }
  }

  void setCategory(String text) {
    setState(() {
      category = text;

      switch (category) {
        case "All Category":
          targetData = data;
          break;

        case "Technology":
          targetData["heading"] = data["technology"];
          List<dynamic> trending = [];
          for (var podcast in targetData["heading"]) {
            if (podcast["rating"] > 50) trending.add(podcast);
          }
          targetData['trending'] = trending;
          break;

        case "News":
          targetData["heading"] = data["news"];
          List<dynamic> trending = [];
          for (var podcast in targetData["heading"]) {
            if (podcast["rating"] > 50) trending.add(podcast);
          }
          targetData['trending'] = trending;
          break;

        case "Politics":
          targetData["heading"] = data["politics"];
          List<dynamic> trending = [];
          for (var podcast in targetData["heading"]) {
            if (podcast["rating"] > 50) trending.add(podcast);
          }
          targetData['trending'] = trending;
          break;
      }
    });
  }

  Future<void> updateUserData(int status) async {
    var rootPath = await getApplicationDocumentsDirectory();
    var path = rootPath.path;

    var clientID = "client_ID";
    var file = File("$path/$clientID");

    var content = await file.readAsString();
    var decodedContent  = jsonDecode(content);

    decodedContent["subscribed"] = status;
    
   file.writeAsString(jsonEncode(decodedContent));
  }

  Future<String> getUserID() async{
    var rootPath =  await getApplicationDocumentsDirectory();
    var path = rootPath.path;
    var file = File("$path/client_ID");

    var content = await file.readAsString();
    var decodedContent = jsonDecode(content);

    return decodedContent["uuid"]; 
  }

  Future<bool> isLoaded() async {
    //await Future.delayed(Duration(seconds: 6));
    /*var testData = TestData();
    testData.init();
    data = testData.data;*/
    print("start loading");

    var url = Uri.https('nomba-hackathon-backend.onrender.com', 'get-today');
    var response = await http.post(url, body: jsonEncode( {'uniqueID': await getUserID()}));
  
    data = jsonDecode(response.body);
    updateUserData(data["billingState"] ? 1: 0);
    return true;
  }

  void playLoadingAnimation() {
    setState(() {
      alpha = animation.value;
    });
    if (animationController.isCompleted) {
      animationController.repeat();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    subscription.cancel();
    super.dispose();
  }

  void checkSubscription() {}

  @override
  void initState() {
    super.initState();
    loadingStatus = isLoaded();

    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.2, end: 1).animate(animationController);
    animationController.forward();

    animationController.addListener(playLoadingAnimation);

    subscription = widget.clientStream.listen((data) {
      if (data[2] == "regular") {
        setState(() => showPlayer = data.last);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // Loading Widget
    var widget = Column(
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(73, 73, 113, alpha),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(73, 73, 113, alpha),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(73, 73, 113, alpha),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(73, 73, 113, alpha),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(73, 73, 113, alpha),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(73, 73, 113, alpha),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
    // Searching podcast
    var searchPodcast = SafeArea(
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                onChanged: (text) {
                  setState(() => this.searchPodcast(text));
                },
                onTap: () {
                  setState(() => isSearching = true);
                },
                controller: textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: "Search Podcast",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(43, 43, 80, 1),
                  ),
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                textController.clear();
                searchedItems = [];
                setState(() => isSearching = false);
              },
              icon: Icon(Icons.close, color: Color.fromRGBO(43, 43, 80, 1)),
            ),
          ],
        ),
      ),
    );

    return FutureBuilder(
      future: loadingStatus,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          animationController.removeListener(playLoadingAnimation);
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    color: Color.fromRGBO(73, 73, 113, 1),
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      spacing: 16,

                      children: [
                        if (showPlayer)
                          MiniPlayer(
                            clientSink: this.widget.clientSink,
                            clientStream: this.widget.clientStream,
                          ),
                        searchPodcast,
                        if (isSearching)
                          PodSubListing(
                            podcast: searchedItems,
                            noCarousel: true,
                            title: "Searched Items",
                          ),
                        if (!isSearching)
                          CategoryWidget(setCategory: setCategory),
                        if (!isSearching)
                          HeadingPodcastList(
                            clientSink: this.widget.clientSink,
                            clientStream: this.widget.clientStream,
                            data: targetData.isEmpty
                                ? data["heading"]
                                : targetData["heading"],
                          ),
                        if (!isSearching)
                          PodSubListing(
                            podcast: targetData.isEmpty
                                ? data["trending"]
                                : targetData["trending"],
                            noCarousel: false,
                            title: "Trending",
                          ),
                        if (!isSearching || category == "All Category")
                          PodSubListing(
                            podcast: data["politics"],
                            noCarousel: true,
                            title: "Politics",
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return widget;
        }
      },
    );
  }
}
