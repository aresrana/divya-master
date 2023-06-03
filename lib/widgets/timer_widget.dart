import 'dart:async';

import 'package:flutter/material.dart';

enum Time { start, pause, reset }

class TimerController extends ValueNotifier<Time> {
  TimerController({Time time = Time.reset}) : super(time);

  void startTimer() => value = Time.start;

  void pauseTimer() => value = Time.pause;

  void resetTimer() => value = Time.reset;
}

class TimerWidget extends StatefulWidget {
  final TimerController controller;

  const TimerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = const Duration();

  Timer? timer;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      switch (widget.controller.value) {
        case Time.start:
          startTimer();
          break;
        case Time.pause:
          stopTimer();
          break;
        case Time.reset:
          reset();
          stopTimer();
          break;
      }
    });
  }

  void reset() => setState(() => duration = const Duration());

  void addTime() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (!mounted) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    if (!mounted) return;

    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Center(child: buildTime());

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$twoDigitMinutes:$twoDigitSeconds',
      style: const TextStyle(
        fontSize: 80,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
