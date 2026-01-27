import 'dart:async';

void main() {
  // 스트림
  // 다른 언어의 채널과 유사하다.
  final controller = StreamController();
  final stream = controller.stream;

  stream.listen((val) => print(val));

  controller.sink.add(1);
  controller.sink.add(2);
  controller.sink.add(3);
  controller.sink.add(4);
}
