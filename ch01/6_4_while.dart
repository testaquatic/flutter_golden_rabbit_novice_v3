void main() {
  int total = 0;

  while (total < 10) {
    total += 1;
  }

  print(total);

  total = 0;

  do {
    total += 1;
  } while (total < 10);

  print(total);
}
