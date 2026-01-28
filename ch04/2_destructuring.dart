class Idol {
  final String name;
  final int age;

  Idol({required this.name, required this.age});
}

void main() {
  final [minji, hearin] = ["민지", "해린"];
  print(minji);
  print(hearin);

  final numbers = [1, 2, 3, 4, 5, 6, 7, 8];
  final [x, y, ..., z] = numbers;
  print(x);
  print(y);
  print(z);

  final minjiMap = {"name": "민지", "age": 19};
  final {"name": name, "age": age} = minjiMap;
  print("name: $name");
  print("age: $age");

  final minji2 = Idol(name: "민지", age: 19);
  final Idol(name: name2, age: age2) = minji2;
  print("name2: $name2");
  print("age2: $age2");
}
