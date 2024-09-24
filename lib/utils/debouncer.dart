import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debouncer<T> {
  final Duration duration;
  final ValueSetter<T> callback;

  Timer? _timer;

  Debouncer(this.duration, this.callback);

  void call(T t) {
    if (_timer != null) _timer!.cancel();

    _timer = Timer(
      duration,
      () => callback(t),
    );
  }

  void dispose() {
    if (_timer != null) _timer!.cancel();
  }
}
