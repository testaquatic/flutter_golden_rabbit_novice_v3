void main() {
  try {
    const String name = "코드팩토리";

    // 오류를 발생시킨다.
    throw Exception("이름이 잘못됐습니다.");

    // ignore: dead_code
    print(name);
  } catch (e) {
    print(e);
  }
}
