import 'dart:isolate';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:podcast/data-widgets/podcast_heading.dart';

class HeadingPodcastList extends StatefulWidget {
  // Podcast Data
  List<dynamic> data;
  Sink clientSink;
  Stream<dynamic> clientStream;

  HeadingPodcastList({
    required this.data,
    required this.clientSink,
    required this.clientStream,
  });
  @override
  State<HeadingPodcastList> createState() => _HeadingPodcastListState();
}

class _HeadingPodcastListState extends State<HeadingPodcastList>
    with TickerProviderStateMixin {
  late Color activeColor;
  var controller = CarouselSliderController();
  var carouselPos = 0;
  late Animation<int> animation;
  late AnimationController animationController;
  var animPos = 1;
  late double width = 0;
  bool isPlaying = false;
  Map<String, dynamic> activePodcast = {};
  @override
  void initState() {
    super.initState();
    // init color to the  color of first heading Podcast
    var color = widget.data[0]["bgColor"] as List<int>;
    var r = color[0];
    var g = color[1];
    var b = color[2];

    widget.clientStream.listen((data) {
      if (data is List && data.contains("regular")) {
        
        activePodcast = data[1];
        activePodcast["isPlaying"] = data[0];

        setState(() {
          print("LOading HERE");
        });

      }
    });
    activeColor = Color.fromRGBO(r, g, b, 1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var height = MediaQuery.of(context).size.height / 4;
    width = MediaQuery.of(context).size.width;
    return Column(
      spacing: 0,
      children: [
        Container(
          color: Color.fromRGBO(83, 83, 123, 1),
          height: height,
          width: width,
          child: CarouselSlider(
            carouselController: controller,
            options: CarouselOptions(
              height: height,
              autoPlay: true,
              onPageChanged: (int pos, CarouselPageChangedReason e) {
                print(pos);
                setState(() => carouselPos = pos);
              },
            ),
            items: [
              for (var item in widget.data)
                PodcastHeading(
                  isPlaying:
                      item["name"] == activePodcast["name"] &&
                      item["url"] == activePodcast["url"] &&
                      item["thumb_nail"] == activePodcast["thumb_nail"] &&
                      activePodcast["isPlaying"],
                  data: item,
                  clientStream: widget.clientStream,
                  clientSink: widget.clientSink,
                ),
            ],
          ),
        ),
        Container(
          color: Color.fromRGBO(83, 83, 123, 1),
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos == 1 ? Colors.lightBlue : Colors.white,
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos == 2 ? Colors.lightBlue : Colors.white,
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos == 3 ? Colors.lightBlue : Colors.white,
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos == 4 ? Colors.lightBlue : Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
