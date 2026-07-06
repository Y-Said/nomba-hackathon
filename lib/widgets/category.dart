import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  void Function(String text) setCategory;
  CategoryWidget({super.key, required this.setCategory});

  @override
  State<CategoryWidget> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryWidget> {
  var activeButton = "All Category";

  void setActiveButton(String name) {
    setState(() => activeButton = name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: [
            FilledButton(
              onPressed: () {
                widget.setCategory("All Category");
                setActiveButton("All Category");
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.all(8.0),
                ),
                backgroundColor: activeButton == "All Category"
                    ? WidgetStatePropertyAll<Color>(
                        Color.fromRGBO(43, 43, 83, 1),
                      )
                    : WidgetStatePropertyAll<Color>(Colors.white),
              ),
              child: Text(
                "All Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: activeButton == "All Category"
                      ? Colors.white
                      : Color.fromRGBO(43, 43, 83, 1),
                ),
              ),
            ),
            FilledButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.all(8.0),
                ),
                backgroundColor: activeButton == "Technology"
                    ? WidgetStatePropertyAll<Color>(
                        Color.fromRGBO(43, 43, 83, 1),
                      )
                    : WidgetStatePropertyAll<Color>(Colors.white),
              ),
              onPressed: () {
                widget.setCategory("Technology");
                setActiveButton("Technology");
              },
              child: Text(
                "Technology",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: activeButton == "Technology"
                      ? Colors.white
                      : Color.fromRGBO(43, 43, 83, 1),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                widget.setCategory("News");
                setActiveButton("News");

              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.all(8.0),
                ),
                backgroundColor: activeButton == "News"
                    ? WidgetStatePropertyAll<Color>(
                        Color.fromRGBO(43, 43, 83, 1),
                      )
                    : WidgetStatePropertyAll<Color>(Colors.white),
              ),

              child: Text(
                "News",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: activeButton == "News"
                      ? Colors.white
                      : Color.fromRGBO(43, 43, 83, 1),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                widget.setCategory("Politics");
                setActiveButton("Politics");
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.all(8.0),
                ),
                backgroundColor: activeButton == "Politics"
                    ? WidgetStatePropertyAll<Color>(
                        Color.fromRGBO(43, 43, 83, 1),
                      )
                    : WidgetStatePropertyAll<Color>(Colors.white),
              ),

              child: Text(
                "Politics",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: activeButton == "Politics"
                      ? Colors.white
                      : Color.fromRGBO(43, 43, 83, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
