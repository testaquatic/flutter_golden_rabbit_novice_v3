// 추상 클래스
// 인터페이스나 트레이트?
abstract class Idol {
  final String name;
  final int membersCount;

  Idol(this.name, this.membersCount);

  void sayName();
  void sayMembersCount();
}

// 추상클래스 구현
class GirlGroup implements Idol {
  final String name;
  final int membersCount;

  GirlGroup(this.name, this.membersCount);

  @override
  void sayName() {
    print("저는 여자 아이돌 ${this.name}입니다.");
  }

  @override
  void sayMembersCount() {
    print("$name 멤버는 $membersCount명입니다.");
  }
}

void main() {
  GirlGroup blackPink = GirlGroup("블랙핑크", 4);

  // 캐스케이드 연산자
  blackPink
    ..sayName()
    ..sayMembersCount();
}
