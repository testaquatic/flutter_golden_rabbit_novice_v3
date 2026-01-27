class Idol {
  final String name;
  final int membersCount;

  Idol(this.name, this.membersCount);

  void sayName() {
    print("저는 ${name}입니다.");
  }

  void sayMembersCount() {
    print("$name 멤버는 $membersCount명입니다.");
  }
}

// Idol 클래스를 상속한다.
class BoyGroup extends Idol with IdolSingMixin {
  BoyGroup(super.name, super.membersCount);

  // 상속받지 않은 메서드
  void sayMale() {
    print("저는 남자 아이돌입니다.");
  }
}

class GirlGroup extends Idol {
  GirlGroup(super.name, super.membersCount);

  // 오버라이드
  @override
  void sayName() {
    print("저는 여자 아이돌 ${this.name}입니다.");
  }
}

// 인터페이스
class GirlGroup2 implements Idol {
  final String name;
  final int membersCount;

  GirlGroup2(this.name, this.membersCount);

  void sayName() {
    print("저는 여자 아이돌 ${this.name}입니다.");
  }

  void sayMembersCount() {
    print("$name 멤버는 $membersCount명입니다.");
  }
}

// 믹스인
mixin IdolSingMixin on Idol {
  void sing() {
    print("${this.name}이 노래를 부릅니다.");
  }
}

void main() {
  BoyGroup bts = BoyGroup("BTS", 7);

  bts.sayName();
  bts.sayMembersCount();
  // 상속받지 않은 메서드 호출
  bts.sayMale();
  // 믹스인 메서드 호출
  bts.sing();

  GirlGroup blackPink = GirlGroup("블랙핑크", 4);

  // 오버라이드된 메서드 호출
  blackPink.sayName();
  blackPink.sayMembersCount();

  GirlGroup2 blackPink2 = GirlGroup2("블랙핑크", 4);

  blackPink2.sayName();
  blackPink2.sayMembersCount();
}
