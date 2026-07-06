import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:podcast/data-widgets/podcast.dart";
import "package:podcast/data-widgets/podcast1.dart";

class PodSubListing extends StatefulWidget {
  List<dynamic> podcast;
  bool showAll = false;
  bool noCarousel;
  String title;
  PodSubListing({
    required this.podcast,
    required this.noCarousel,
    required this.title,
  });

  @override
  State<PodSubListing> createState() => _PodSubListingState();
}

class _PodSubListingState extends State<PodSubListing> {
  int carouselPos = 0;

  void setShowAllState() {
    setState(() => widget.showAll = !widget.showAll);
  }

  @override
  Widget build(BuildContext context) {
    var header = Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          widget.noCarousel 
              ? Text("")
              : InkWell(
                  onTap: () {
                    setShowAllState();
                  },
                  child: Text(
                    widget.showAll ? "Collapse" :"Show All" ,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 138, 255, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
    // TODO: implement build
    return widget.showAll
        ? Column(
          spacing:8,
          children: [
            header,
            Container(
                height: 80 * widget.podcast.length.toDouble(),
                child: GridView.count(
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  primary: false,
                  crossAxisCount: 2,
                  children: [for (var dt in widget.podcast) Podcast1(data: dt)],
                ),
              ),
          ],
        )
        : Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: BoxBorder.symmetric(
                horizontal: BorderSide(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Column(
              spacing: 8,
              children: [
                header,
                widget.noCarousel
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          child: Row(
                            children: [
                              for (var dt in widget.podcast) Podcast1(data: dt),
                            ],
                          ),
                        ),
                      )
                    : CarouselSlider(
                        items: [
                          for (var dt in widget.podcast) Podcast(data: dt),
                        ],
                        options: CarouselOptions(
                          height: 150,
                          autoPlay: true,
                          onPageChanged:
                              (int pos, CarouselPageChangedReason e) {
                                setState(() => carouselPos = pos);
                              },
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
                        color: carouselPos == 1
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
                        color: carouselPos == 3
                            ? Colors.lightBlue
                            : Colors.white,
                      ),
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: carouselPos == 4
                            ? Colors.lightBlue
                            : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
