import 'dart:async';

import 'package:flutter/material.dart';

class ProgressController {
  static const double smoothnessConstant = 250;

  final Duration duration;
  final Duration tickPeriod;

  Timer _timer;
  Timer _periodicTimer;

  Stream<void> get progressStream => _progressController.stream;
  StreamController<void> _progressController =
      StreamController<void>.broadcast();

  Stream<void> get timeoutStream => _timeoutController.stream;
  StreamController<void> _timeoutController =
      StreamController<void>.broadcast();

  double get progress => _progress;
  double _progress = 0;

  ProgressController({@required this.duration})
      : assert(duration != null),
        tickPeriod = _calculateTickPeriod(duration);

  void start() {
    _timer = Timer(duration, () {
      cancelTimers();
      _setProgressAndNotify(1);
      _timeoutController.add(null);
    });

    _periodicTimer = Timer.periodic(
      tickPeriod,
      (Timer timer) {
        double progress = _calculateProgress(timer);
        _setProgressAndNotify(progress);
      },
    );
  }
  void restart() {
    cancelTimers();
    start();
  }

  Future<void> dispose() async {
    await _cancelStreams();
    cancelTimers();
  }

  double _calculateProgress(Timer timer) {
    double progress = timer.tick / smoothnessConstant;

    if (progress > 1) return 1;
    if (progress < 0) return 0;
    return progress;
  }

  void _setProgressAndNotify(double value) {
    _progress = value;
    _progressController.add(null);
  }

  Future<void> _cancelStreams() async {
    if (!_progressController.isClosed) await _progressController.close();
    if (!_timeoutController.isClosed) await _timeoutController.close();
  }

  void cancelTimers() {
    if (_timer?.isActive == true) _timer.cancel();
    if (_periodicTimer?.isActive == true) _periodicTimer.cancel();
  }

  static Duration _calculateTickPeriod(Duration duration) {
    double tickPeriodMs = duration.inMilliseconds / smoothnessConstant;
    return Duration(milliseconds: tickPeriodMs.toInt());
  }
}


class RestartableCircularProgressIndicator extends StatefulWidget {
  final ProgressController controller;
  final VoidCallback onTimeout;

  RestartableCircularProgressIndicator({
    Key key,
    @required this.controller,
    this.onTimeout,
  })  : assert(controller != null),
        super(key: key);

  @override
  _RestartableCircularProgressIndicatorState createState() =>
      _RestartableCircularProgressIndicatorState();
}

class _RestartableCircularProgressIndicatorState
    extends State<RestartableCircularProgressIndicator> {
  ProgressController get controller => widget.controller;

  VoidCallback get onTimeout => widget.onTimeout;

  @override
  void initState() {
    super.initState();
    controller.progressStream.listen((_) => updateState());
    controller.timeoutStream.listen((_) => onTimeout());
  }
@override
  void setState(fn) {
    if(mounted){
super.setState(fn);
    }   
  }
   @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.green[100],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      value: controller.progress,
      minHeight: 20.0,
    );
  }
    void updateState() => setState(() {});
}