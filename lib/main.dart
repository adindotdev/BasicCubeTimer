import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new BasicCubeTimer());

class BasicCubeTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
      title: 'Basic Cube Timer',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BasicCubeTimerHome(title: 'Basic Cube Timer'),
    );
  }
}

class BasicCubeTimerHome extends StatefulWidget {
  BasicCubeTimerHome({Key key, this.title}) : super(key: key);

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

  int _getBestSingle() {
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

  int _getLastSingle() {
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
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new GestureDetector(
        onTap: _tapTimer,
        child: new Scaffold(
          appBar: new AppBar(title: new Text(widget.title)),
          body: new Center(
            child: new Column(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Best single:",
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .apply(fontSizeFactor: _statsFontSize),
                        ),
                        new Text(
                          "Last single:",
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          _formatTime(_getBestSingle()),
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .apply(fontSizeFactor: _statsFontSize),
                        ),
                        new Text(
                          _formatTime(_getLastSingle()),
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
    );
  }
}
