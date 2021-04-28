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

  bool _isScriptRunning = false;

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

  void _openNewWorkspace() async {
    await controller?.evaluateJavascript('clearWorkspace()');
  }

  Future<String> _getWorkspace() async {
    var xml = await controller?.evaluateJavascript('goWorkspaceToXml()');
    print('_getWorkspace#############$xml##########');
    return xml;
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
      // assetsBasePath: 'assets/web',
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

  _addProject(String name, String proj) {
    setState(() {
      projects[name] = proj;
      final s = json.encode(projects);
      prefs.setString('all_projects', s);
    });
  }

  _delProject(String name) {
    setState(() {
      projects.remove(name);
      final s = json.encode(projects);
      prefs.setString('all_projects', s);
    });
  }

  _saveProject(String name, String proj) {
    setState(() {
      projects[name] = proj;
      final s = json.encode(projects);
      prefs.setString('all_projects', s);
    });
  }

  _saveCurrentProject() async {
    var xml = await _getWorkspace();
    _saveProject(currentProject, xml);
  }

  void _applyCurrentProjectToDevice() async {
    try {
      final pythonCode =
          await controller?.evaluateJavascript('goWorkspaceToCode()');
      // await context.read<MaeGo>().runPythonCode(pythonCode);
      setState(() {
        _isScriptRunning = false;
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  _newProjectDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final _formKey = GlobalKey<FormState>();
          final projectNameTController = TextEditingController();

          return SimpleDialog(
            title: const Text('保存工程'),
            children: [
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: projectNameTController,
                        decoration: const InputDecoration(
                          hintText: '输入新的工程名称',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '工程名称不能为空';
                          }
                          if (projects[value] != null) {
                            return '该工程名已存在';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              // Process data.
                            } else {
                              final name = projectNameTController.text;
                              currentProject = name;
                              _openNewWorkspace();
                              String xml = await _getWorkspace();
                              _addProject(name, xml);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('"$name"保存成功')));
                            }
                          },
                          child: Text('保存'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
                _delProject(name);
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
                        // debuggingEnabled: true,
                        // initialUrl: 'http://$address:$port',
                        initialUrl: 'http://$address:$port/CN.html',
                        // initialUrl: 'http://127.0.0.1/CN.html',
                        // initialUrl: 'http://bing.com',
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController controller) {
                          this.controller = controller;
                        },
                      ),
                    ),
                    Container(
                      // color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 38,
                            width: 300,
                            // color: Colors.red,
                            alignment: Alignment.topLeft,
                            // margin: EdgeInsets.fromLTRB(1, 0, 0, 0),
                            child: TextButton(
                              // padding: EdgeInsets.fromLTRB(10, 0, 102, 0),
                              // color: Colors.white,
                              // shape: CircleBorder(),
                              // textColor: Colors.grey,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.grey,
                                size: 22,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  color: Colors.white,
                                  textColor: Colors.grey,
                                  padding: EdgeInsets.all(8),
                                  onPressed: () {
                                    _newProjectDialog();
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                  shape: CircleBorder(),
                                ),
                                MaterialButton(
                                  color: Colors.white,
                                  textColor: Colors.grey,
                                  padding: EdgeInsets.all(8),
                                  onPressed: () {
                                    _saveCurrentProject();
                                  },
                                  child: Icon(
                                    Icons.save,
                                    size: 30,
                                  ),
                                  shape: CircleBorder(),
                                ),
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
                                _isScriptRunning
                                    ? MaterialButton(
                                        color: Colors.red,
                                        textColor: Colors.white,
                                        padding: EdgeInsets.all(8),
                                        onPressed: () async {
                                          // await context
                                          //     .read<MaeGo>()
                                          //     .stopPythonCode();
                                          setState(() {
                                            _isScriptRunning = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.stop,
                                          size: 30,
                                        ),
                                        shape: CircleBorder(),
                                      )
                                    : MaterialButton(
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        padding: EdgeInsets.all(8),
                                        onPressed: () {
                                          setState(() {
                                            _isScriptRunning = true;
                                          });
                                          _applyCurrentProjectToDevice();
                                        },
                                        child: Icon(
                                          Icons.play_arrow,
                                          size: 30,
                                        ),
                                        shape: CircleBorder(),
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
