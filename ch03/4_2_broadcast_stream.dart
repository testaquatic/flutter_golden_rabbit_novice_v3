import 'dart:async';

// 스트림을 반환하는 함수는 async*하고 yield르 사용한다.
Stream<String> calculate(int number) async* {
  for (int i = 0; i < 5; i++) {
    yield 'i = $i';
    await Future.delayed(Duration(seconds: 1));
  }
}

void playStream() {
  calculate(1).listen((val) {
    print(val);
  });
}

void main() {
  final controller = StreamController();
  final stream = controller.stream.asBroadcastStream();

  stream.listen((val) {
    print("listening 1");
    print(val);
  });

  stream.listen((val) {
    print("listening 2");
    print(val);
  });

  controller.sink.add(1);
  controller.sink.add(2);
  controller.sink.add(3);

  playStream();
}
