import "package:flutter/material.dart";

class PlayListEpisode extends StatefulWidget {
  @override
  State<PlayListEpisode> createState() => _PlayListEpisodeState();
}

class _PlayListEpisodeState extends State<PlayListEpisode> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              size:32,
              Icons.podcasts_outlined,
              color: Color.fromRGBO(83, 83, 123, 1),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Text(
                "Play List Name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Play list",
                style: TextStyle(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              spacing:4,
              children: [
                Icon(
                  size:32,
                  Icons.play_arrow_outlined,
                  color: Color.fromRGBO(83, 83, 123, 1),
                ),
                Icon(
                  size:32,
                  Icons.star_border_outlined,
                  color: Color.fromRGBO(83, 83, 123, 1),
                )
              ],
            ),
          ),
],
      ),
    );
  }
}
