// 제너릭
class Cache<T> {
  final T data;

  Cache({required this.data});
}

void main() {
  final cache = Cache(data: [1, 2, 3]);

  print(cache.data.reduce((value, element) => value + element));
}
