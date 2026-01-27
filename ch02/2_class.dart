// 클래스 선언
class Idol {
  // 필드
  final String name;

  // 생성자
  Idol(this.name);

  // 메서드
  void sayName() {
    // this
    print("저는 ${this.name}입니다.");
    print("저는 ${name}입니다.");
  }
}

void main() {
  // 인스턴스 생성
  final Idol blackpink = Idol("블랙핑크");
  // 메서드 호출
  blackpink.sayName();

  final bts = Idol("BTS");
  bts.sayName();
}
