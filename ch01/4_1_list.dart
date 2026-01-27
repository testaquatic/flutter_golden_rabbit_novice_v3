void main() {
  // List 타입
  List<String> blackPink = ["리사", "지수", "제니", "로제"];

  // 접근 방식은 다른 언어와 유사하다.
  print(blackPink);
  print(blackPink[0]);
  print(blackPink[3]);

  // 길이
  // 자바스크립트와 유사하다.
  print(blackPink.length);

  // 요소의 수정 역시 다른 언어와 유사하다.
  blackPink[3] = "코드팩토리";
  print(blackPink);
}
