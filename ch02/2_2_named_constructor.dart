class Idol {
  final String name;
  final int membersCount;

  Idol(this.name, this.membersCount);

  // 자바스크립트의 static?
  Idol.fromMap(Map<String, dynamic> map)
    : this.name = map["name"],
      this.membersCount = map["membersCount"];

  void sayName() {
    print("저는 ${name}입니다. ${name} 멤버는 ${membersCount}명입니다.");
  }
}

void main() {
  Idol blackpink = Idol("블랙핑크", 4);
  blackpink.sayName();

  Idol bts = Idol.fromMap({"name": "BTS", "membersCount": 7});
  bts.sayName();
}
