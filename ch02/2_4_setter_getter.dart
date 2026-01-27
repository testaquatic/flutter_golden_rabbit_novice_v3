class Idol {
  // 프라이빗 변수, 파일 스코프
  String _name = "블릭핑크";

  // getter
  String get name {
    return _name;
  }

  // setter
  set name(String name) {
    _name = name;
  }
}

void main() {
  Idol blackpink = Idol();

  blackpink.name = "에이핑크";
  print(blackpink.name); // "에이핑크
}
