void main() {
  List<String> blackPinkList = ["리사", "지수", "제니", "로제"];

  // 러스트나 자바스크립트의 map과 유사한 기능이다.
  final newBlackPink = blackPinkList.map((name) => "블랙핑크 $name");
  // 이터러블
  print(newBlackPink);
  // 리스트
  print(newBlackPink.toList());
}
