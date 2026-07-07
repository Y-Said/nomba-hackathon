import "package:flutter/material.dart";
import "package:podcast/data-widgets/play_list_option.dart";
import "package:podcast/widgets/play_list_episode.dart";

class PlayInside extends StatefulWidget {
  @override
  State<PlayInside> createState() => _PlayInsideState();
}

class _PlayInsideState extends State<PlayInside> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(8),
      color: Color.fromRGBO(83, 83, 123, 1),
      child: Column(
        spacing: 16,
        children: [
          SafeArea(child: PlayListOption()),
          for (var i in [3, 3, 34, 3, 4, 3]) PlayListEpisode(),
        ],
      ),
    );
  }
}
