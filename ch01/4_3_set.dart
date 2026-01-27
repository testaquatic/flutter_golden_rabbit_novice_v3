void main() {
  // 리사가 두번 반복됐다.
  // ignore: equal_elements_in_set
  Set<String> blackPinkList = {"리사", "지수", "제니", "로제", "리사"};
  print(blackPinkList);
  print(blackPinkList.contains("리사"));
  print(blackPinkList.toList());

  List<String> blackPink2 = ["로제", "지수", "지수"];
  print(Set.from(blackPink2));
}
