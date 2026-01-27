void main() {
  List<String> blackPinkList = ["리사", "지수", "제니", "로제"];

  // 러스트나 자바스크립트의 filter와 유사한 기능이다.
  final newList = blackPinkList.where((name) => name == "리사" || name == "지수");
  // 이터러블
  print(newList);
  // 리스트
  print(newList.toList());
}
