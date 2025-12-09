import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudokats/application/providers.dart';

class ElapsedTime extends ConsumerStatefulWidget {
  const ElapsedTime({super.key});

  @override
  ConsumerState<ElapsedTime> createState() => _EllapsedTimeState();
}

class _EllapsedTimeState extends ConsumerState<ElapsedTime> {
  late Timer _timer;
  late Duration _elapsedTime;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
    _timer.cancel();
    _elapsedTime = Duration.zero;
  }

  _startTimer({Duration from = Duration.zero}) {
    _elapsedTime = from;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += Duration(seconds: 1);
      });
      ref.read(gameServiceProvider).updateElapsedTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final game = ref.watch(gameProvider);
    if (game.grid.isEmpty) {
      _timer.cancel();
      _elapsedTime = Duration.zero;
      return Text('');
    }
    if (!_timer.isActive) {
      final game = ref.read(gameProvider);
      _elapsedTime = game.elapsedTime;
      _startTimer(from: _elapsedTime);
    }

    final minutes = _elapsedTime.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = _elapsedTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return Text('$minutes:$seconds', style: themeData.textTheme.titleMedium);
  }
}
