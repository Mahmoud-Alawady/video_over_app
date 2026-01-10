import 'dart:async';

extension StreamThrottleExtension<T> on Stream<T> {
  /// Emits at most one value every [duration].
  Stream<T> throttle(Duration duration) {
    StreamController<T>? controller;
    T? lastValue;
    bool ready = true;

    controller = StreamController<T>(
      onListen: () {
        listen(
          (event) {
            lastValue = event;
            if (ready) {
              controller!.add(lastValue as T);
              ready = false;
              Future.delayed(duration, () => ready = true);
            }
          },
          onError: controller!.addError,
          onDone: controller.close,
          cancelOnError: false,
        );
      },
    );

    return controller.stream;
  }
}
