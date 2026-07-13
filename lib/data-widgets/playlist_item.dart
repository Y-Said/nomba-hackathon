import "package:flutter/material.dart";

class PlaylistItem extends StatefulWidget {
  Map<String, dynamic> data;
  void Function(String) setSelectedPlaylist;
  bool isSelected;

  PlaylistItem({
    required this.data,
    required this.isSelected,
    required this.setSelectedPlaylist,
  });

  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  @override
  Widget build(BuildContext context) {
    print("${widget.isSelected} WHAT HAPPENED? ");
    // TODO: implement build
    return InkWell(
      onLongPress: () {
        widget.setSelectedPlaylist(widget.data["name"]);
        print("${widget.isSelected} this widget is Selected ");
      },
      child: Container(
        color: !widget.isSelected
            ? Color.fromRGBO(83, 83, 123, 0)
            : Color.fromRGBO(63, 63, 103, 1),
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                size: 32,
                Icons.queue_music_rounded,
                color: Color.fromRGBO(83, 83, 123, 1),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text(
                  widget.data["name"] as String,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${widget.data["episodes"]?.length}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white, size: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
