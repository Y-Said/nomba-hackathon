import "dart:convert";
import "dart:io";
import "package:podcast/widgets/main_app.dart";
import "package:uuid/uuid.dart";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";

class LaunchingWidget extends StatefulWidget {
  @override
  State<LaunchingWidget> createState() => _LaunchingWidgetState();
}

class _LaunchingWidgetState extends State<LaunchingWidget> {
  var idFileExists = false;
  // File For Storing client subscription detail ie unique id
  var clientID = "client_ID";

  // Resolve whether client_ID file exists or not,
  // file normally used for storing subscription details and user unique id.
  Future<bool> isIDExists() async {
    var path = await getApplicationDocumentsDirectory();
    var pathName = path.path;

    var pathObject = File("$pathName/$clientID");
    
    var pathExists = await pathObject.exists();
    setState(() => idFileExists = pathExists);
    
    return pathExists;
  }

  @override
  void initState() {
    super.initState();
    isIDExists();
  }

  Future<void> createClientID() async {
    var rootPath = await getApplicationDocumentsDirectory();
    var clientIDFile = File("${rootPath.path}/$clientID");
    await clientIDFile.create();
    var uniqueId = Uuid().v4();

    // Client subscription details
    Map<String, String> config = {};
    config["uuid"] = uniqueId;
    config["subscribed"] = "0";

    var serializedData = jsonEncode(config);
    clientIDFile.writeAsString(serializedData);
  
    setState(() {
      idFileExists = true;
    });
  }

  @override
  Widget build(Object context) {
    if (idFileExists) {
      return MaterialApp(home: MainApp());
    } else {
      // Container For getting started widget
      // When user first open the app for first time.
      var container = Container(
        color: Color.fromRGBO(83, 83, 123, 1),
        padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 8.0),
        child: Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 362,
                  height: 299,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color.fromRGBO(230, 230, 230, 1),
                  ),
                  child: Image.asset(
                    "images/getting-started.png",
                    width: 356,
                    height: 299,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Listen To Premium Podcasts",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
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
                        createClientID();
                      },
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(83, 83, 123, 1),
          ),
        ),
        home: container,
      );
    }
  }
}
