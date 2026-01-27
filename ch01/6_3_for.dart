void main() {
  for (int i = 0; i < 3; i++) {
    print(i);
  }

  const List<int> numberList = [3, 6, 9];

  for (final int number in numberList) {
    print(number);
  }
}
