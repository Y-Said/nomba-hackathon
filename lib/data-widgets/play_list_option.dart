import "package:flutter/material.dart";

class PlayListOption extends StatefulWidget {
  @override
  State<PlayListOption> createState() => _PlayListOptionState();
}

class _PlayListOptionState extends State<PlayListOption> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: Colors.white, onPressed: () {}),
          Text(
            "Playlist Content",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.sort, color: Colors.white, size: 22),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
