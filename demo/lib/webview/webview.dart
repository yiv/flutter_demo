import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  WebviewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  SharedPreferences prefs;
  bool isListening = false;
  String address;
  int port;
  WebViewController controller;
  Map<String, String> projects = {};
  String currentProject;


  void _openWorkspace(String name) async {
    final xml = projects[name];
    try {
      await controller?.evaluateJavascript('clearWorkspace()');
      await controller?.evaluateJavascript('goXmlToWorkspace(\'$xml\')');
    } catch (e) {
      print('_openWorkspace, err=$e, name=$name, xml=$xml');
      throw e;
    }
  }

  @override
  initState() {
    _initServer();
    _initSharedPreferences();
    super.initState();
  }

  _initServer() async {
    final server = new LocalAssetsServer(
      address: InternetAddress.loopbackIPv4,
      assetsBasePath: 'assets/blockly',
    );

    final address = await server.serve();

    setState(() {
      this.address = address.address;
      port = server.boundPort;
      isListening = true;

      print('address=$address, port=$port');
    });
  }

  _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _loadProjects();
  }

  _loadProjects() async {
    projects['示例8'] = await rootBundle.loadString('assets/demo/示例8.xml');

    var s = prefs.getString('all_projects');
    if (s != null) {
      var userProjects = (json.decode(s) as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
      projects.addAll(userProjects);
    }
  }





  @override
  Widget build(BuildContext context) {
     _loadProjects();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: projects.keys.toList().length,
          itemBuilder: (context, index) {
            final name = projects.keys.toList()[index];
            return Dismissible(
              key: Key(name),
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: AlignmentDirectional.centerStart,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                onTap: () {
                  currentProject = name;
                  _openWorkspace(name);
                  Navigator.pop(context);
                },
                title: Text(name),
              ),
              onDismissed: (direction) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('"$name"已被删除')));
              },
            );
          },
        ),
      ),
      body: isListening
          ? Container(
              color: Color.fromARGB(255, 240, 240, 240),
              // color: Colors.red,
              child: SafeArea(
                left: true,
                right: true,
                bottom: false,
                top: false,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.red,
                      child: WebView(
                        initialUrl: 'http://$address:$port/CN.html',
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController controller) {
                          this.controller = controller;
                        },
                      ),
                    ),
                    Container(
                      // color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // color: Colors.red,
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Builder(
                                  builder: (BuildContext context) {
                                    return MaterialButton(
                                      color: Colors.white,
                                      textColor: Colors.grey,
                                      padding: EdgeInsets.all(8),
                                      onPressed: () {
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      child: Icon(
                                        Icons.list,
                                        size: 30,
                                      ),
                                      shape: CircleBorder(),
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
