import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(new BasicCubeTimer());

class BasicCubeTimer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Basic Cube Timer',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new BasicCubeTimerHome(title: 'Basic Cube Timer'),
    );
  }
}

class BasicCubeTimerHome extends StatefulWidget {
  BasicCubeTimerHome({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _BasicCubeTimerState createState() => new _BasicCubeTimerState();
}

class _BasicCubeTimerState extends State<BasicCubeTimerHome> {
  static final refreshRate = const Duration(milliseconds: 25);

  //double _time = 0.0; TODO actually use this
  String _formattedTime = "0.000";
  Stopwatch _stopwatch = new Stopwatch();

  void _tapTimer() {
    setState(() {
      if (!_stopwatch.isRunning) {
        _stopwatch.reset();
        _stopwatch.start();
        new Timer.periodic(refreshRate, (Timer t) => setStateIfRunning());
      } else {
        _stopwatch.stop();
      }
    });
  }

  void setStateIfRunning() {
    if (_stopwatch.isRunning) {
      _formattedTime =
          (_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(3);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new GestureDetector(
        onTap: _tapTimer,
        child: new Scaffold(
          body: new Center(
            // Center is a layout widget. It takes a single child and positions
            // it in the middle of the parent.
            child: new Column(
              // Column is also layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit
              // its children horizontally, and tries to be as tall as its
              // parent.
              //
              // Invoke "debug paint" (press "p" in the console where you ran
              // "flutter run", or select "Toggle Debug Paint" from the Flutter
              // tool window in IntelliJ) to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself
              // and how it positions its children. Here we use
              // mainAxisAlignment to center the children vertically; the main
              // axis here is the vertical axis because Columns are vertical
              // (the cross axis would be horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  _formattedTime,
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .apply(fontSizeFactor: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
