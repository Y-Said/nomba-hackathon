import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:podcast/data-widgets/heading_podcast_list.dart';
import 'package:podcast/widgets/category.dart';

// List of Discovered
class PodcastList extends StatefulWidget {
  Map<String, dynamic> data;

  PodcastList({required this.data});

  @override
  State<PodcastList> createState() => _PodcastListState();
}

class _PodcastListState extends State<PodcastList> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              icon: Icon(Icons.close, color: Color.fromRGBO(43, 43, 80, 1)),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Expanded(
        child: Container(
          color: Color.fromRGBO(73, 73, 113, 1),
          padding: EdgeInsets.only(bottom:16),
          child: Column(
            spacing: 16,

            children: [
              searchPodcast,
              CategoryWidget(),
              HeadingPodcastList(data: widget.data["heading"]),
            ],
          ),
        ),
      ),
    );
  }
}
