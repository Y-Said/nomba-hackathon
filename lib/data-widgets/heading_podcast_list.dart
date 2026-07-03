import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HeadingPodcastList extends StatefulWidget {
  // Podcast Data
  List<dynamic> data;

  HeadingPodcastList({required this.data});
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

  @override
  void initState() {
    super.initState();
    // init color to the  color of first heading Podcast
    var color = widget.data[0]["bgColor"] as List<int>;
    var r = color[0];
    var g = color[1];
    var b = color[2];

    activeColor = Color.fromRGBO(r, g, b, 1);
  }

  // Build Individual carousel item
  Widget itemBuilder(Map<String, dynamic> data, double width) {
    // init color to the  color of first heading Podcast
    var color = data["bgColor"] as List<int>;
    var r = color[0];
    var g = color[1];
    var b = color[2];

    activeColor = Color.fromRGBO(r, g, b, 1);
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
            Image.asset(data["thumb_nail"], fit: BoxFit.contain),
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_filled_outlined,
                        size: 22,
                        color: Color.fromRGBO(38, 39, 59, 1),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "Play Online",
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
            items: [for (var item in widget.data) itemBuilder(item, width)],
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
                color: carouselPos  == 1
                    ? Colors.lightBlue
                    : Colors.white,
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos == 2
                    ? Colors.lightBlue
                    : Colors.white,
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos  == 3
                    ? Colors.lightBlue
                    : Colors.white,
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: carouselPos  == 4
                    ? Colors.lightBlue
                    : Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
