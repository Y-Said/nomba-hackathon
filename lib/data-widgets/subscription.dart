import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:podcast/widgets/webview.dart';

class Subscription extends StatefulWidget {
  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var agreed = false;
  var pressed = false;
  var checkoutUrl = "";

  Future<String> getUserID() async {
    var rootPath = await getApplicationDocumentsDirectory();
    var path = rootPath.path;
    var file = File("$path/client_ID");

    var content = await file.readAsString();
    var decodedContent = jsonDecode(content);

    return decodedContent["uuid"];
  }

  Future<void> getCheckoutUrl() async {
    var uri = Uri.https(
      "nomba-hackathon-backend.onrender.com","checkout"
    );
    var response = await http.post(
      uri,
      body: jsonEncode({"uniqueID": await getUserID()}),
    );
    var decodedData = jsonDecode(response.body);

    setState(() {
      checkoutUrl = decodedData["url"];
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // TODO: implement build
    return checkoutUrl != ""
        ? WebView(url: checkoutUrl)
        : Container(
            color: Color.fromRGBO(83, 83, 123, 1),
            child: Column(
              spacing: 16,
              children: [
                SafeArea(
                  child: Container(
                    width: width,
                    color: Color.fromRGBO(83, 83, 113, 1),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subscription",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    spacing: 8,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        color: Color.fromRGBO(0, 138, 255, 1),
                        child: Text(
                          "Subscribe to get more premium content",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Benifits",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "1. You can manage your playlist",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "2. You receive premium content daily",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: BoxBorder.all(
                            color: agreed ? Colors.blueAccent : Colors.white,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              agreed = !agreed;
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: agreed
                                    ? Colors.blueAccent
                                    : Color.fromRGBO(230, 230, 230, 1),
                                size: 22,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 4,
                                children: [
                                  Text(
                                    "Monthly Subscription",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Price NGN/Month N1000",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: BoxBorder.all(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Color.fromRGBO(230, 230, 230, 1),
                                size: 22,
                              ),
                              onPressed: () {},
                            ),
                            Text(
                              "Auto Renewal Monthly",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                FilledButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 64),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      Color.fromRGBO(0, 138, 255, 1),
                    ),
                  ),
                  onPressed: () {
                    if (agreed) {
                      getCheckoutUrl();
                    }
                  },
                  child: Text(
                    "Subscribe",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
