import 'dart:async';
import 'dart:core';
import 'dart:math';

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
  final _displayTimeFontSize = 1.75;
  final _statsFontSize = 0.5;
  final _refreshDelay = const Duration(milliseconds: 25);

  bool _useMilliseconds = false; //TODO add ability to change
  Stopwatch _stopwatch = new Stopwatch();
  List<int> _listOfTimes = new List();
  List<int> _listOfAvgOfFive = new List();

  void _tapTimer() {
    setState(() {
      if (!_stopwatch.isRunning) {
        _stopwatch.reset();
        _stopwatch.start();
        new Timer.periodic(_refreshDelay, (Timer t) => _setStateIfRunning(t));
      } else {
        _stopwatch.stop();
        _listOfTimes.add(_stopwatch.elapsedMilliseconds);
        if (_getLastAvgOfFive() != null) {
          _listOfAvgOfFive.add(_getLastAvgOfFive());
        }
      }
    });
  }

  void _setStateIfRunning(Timer t) {
    setState(() {
      if (!_stopwatch.isRunning && t.isActive) {
        t.cancel();
      }
    });
  }

  String _formatTime(int milliseconds) {
    if (milliseconds != null) {
      if (milliseconds >= 60000) {
        int minutes = milliseconds ~/ 60000;
        int seconds = (milliseconds % (minutes * 60000));
        if (seconds < 10000) {
          return "$minutes:0" +
              (seconds / 1000.0).toStringAsFixed(_useMilliseconds ? 3 : 2);
        }
        return "$minutes:" +
            (seconds / 1000.0).toStringAsFixed(_useMilliseconds ? 3 : 2);
      }
      return (milliseconds / 1000.0).toStringAsFixed(_useMilliseconds ? 3 : 2);
    }
    return "N/a";
  }

  String _getDisplayTime() {
    return _formatTime(_stopwatch.elapsedMilliseconds);
  }

  int _getBestTime() {
    if (_listOfTimes.isNotEmpty) {
      return _listOfTimes.reduce(min);
    }
    return null;
  }

  int _getBestAvgOfFive() {
    if (_listOfAvgOfFive.isNotEmpty) {
      return _listOfAvgOfFive.reduce(min);
    }
    return null;
  }

  int _getLastTime() {
    if (_listOfTimes.length >= 2) {
      if (_stopwatch.isRunning) {
        return _listOfTimes.last;
      } else {
        return _listOfTimes[_listOfTimes.length - 2];
      }
    }
    return null;
  }

  int _getLastAvgOfFive() {
    if (_listOfTimes.length >= 5) {
      List<int> lastFiveTimes = _listOfTimes
          .getRange(_listOfTimes.length - 5, _listOfTimes.length)
          .toList();
      lastFiveTimes.removeWhere((int) =>
          int == _listOfTimes.reduce(max) || int == _listOfTimes.reduce(min));
      int sumOfLastFiveTimes = 0;
      for (int i in lastFiveTimes) {
        sumOfLastFiveTimes += i;
      }
      return sumOfLastFiveTimes ~/ 3;
    }
    return null;
  }

  Future<bool> _onWillPop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _stopwatch.reset();
      return new Future(() => false);
    }
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Short practice eh...'),
                content: new Text('Are you really sure you want to exit?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created
          // by the App.build method, and use it to set our appbar title.
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
                    _getDisplayTime(),
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .apply(fontSizeFactor: _displayTimeFontSize),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Best time:",
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                          new Text(
                            "Last time:",
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                          new Text(
                            "Best Ao5:",
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                          new Text(
                            "Last Ao5:",
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                        ],
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            _formatTime(_getBestTime()),
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                          new Text(
                            _formatTime(_getLastTime()),
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                          new Text(
                            _formatTime(_getBestAvgOfFive()),
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                          new Text(
                            _formatTime(_getLastAvgOfFive()),
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(fontSizeFactor: _statsFontSize),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
