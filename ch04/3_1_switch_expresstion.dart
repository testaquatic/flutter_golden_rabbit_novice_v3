void main() {
  const String dayKor = "월요일";

  // 러스트의 match하고 유사한듯
  String dayEnglish = switch (dayKor) {
    "월요일" => "Monday",
    "화요일" => "Tuesday",
    "수요일" => "Wednesday",
    "목요일" => "Thursday",
    "금요일" => "Friday",
    "토요일" => "Saturday",
    "일요일" => "Sunday",
    _ => "Unknown",
  };

  print(dayEnglish);

  switcher("aaa");
  switcher([1, 2]);
  switcher([3, 4, 5]);
  switcher([6, 7]);
  switcher(("민지", 19));
  switcher(8);

  // 가능한 경우의 수는 true, false, null
  bool? val;

  switch (val) {
    case true:
      print("true");
      break;
    case false:
      print("false");
      break;
    // 아래를 입력하지 않으면 오류
    default:
      print("null");
  }

  // 러스트의 매치가드
  (int a, int b) val2 = (1, -1);
  switch (val2) {
    case (1, _) when val2.$2 > 0:
      print("1, _");
      break;
    default:
      print("default");
  }
}

void switcher(dynamic anything) {
  switch (anything) {
    case "aaa":
      print("match: aaa");
      break;
    case [1, 2]:
      print("match: [1, 2]");
      break;
    case [_, _, _]:
      print("match [_,_,_]");
      break;
    case [int a, int b]:
      print("match: [int $a, int $b]");
      break;
    case (String a, int b):
      print("match: (String $a, int $b)");
      break;
    default:
      print("no match");
  }
}
