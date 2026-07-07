import "package:flutter/material.dart";
import "package:podcast/widgets/play_list_episode.dart";
class Podcasts extends StatefulWidget {
  @override
  State<Podcasts> createState() => _PodcastsState();
}

class _PodcastsState extends State<Podcasts> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(8),
      color: Color.fromRGBO(83, 83, 123, 1),
      child: Column(
        spacing: 16,
        children: [
          SafeArea(child: Text("All Podcast",style:TextStyle(color:Colors.white,fontSize:20))),
          for (var i in [3, 3, 34, 3, 4, 3]) PlayListEpisode(),
        ],
      ),
    );
  
  }
}