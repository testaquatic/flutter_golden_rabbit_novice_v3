void main() {
  // 튜플?
  (String, int, bool) minji = ("민지", 20, true);
  print(minji);
  // 필드 접근
  print(minji.$1);
  print(minji.$2);
  print(minji.$3);
  // 네임드 파라미터
  ({String name, int age}) minji2 = (name: "민지", age: 20);
  print(minji2);
  // 필드 접근
  print(minji2.name);
}
