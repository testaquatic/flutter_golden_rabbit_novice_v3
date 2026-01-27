enum Status { approved, pending, rejected }

void main() {
  const Status status = Status.approved;

  switch (status) {
    case Status.approved:
      print("승인 상태입니다.");
      break;
    case Status.pending:
      print("대기 상태입니다.");
      break;
    case Status.rejected:
      print("거절 상태입니다.");
      break;
    // ignore: unreachable_switch_default
    default:
      print("알 수 없는 상태입니다.");
  }

  // Status의 모든 값을 출력한다.
  print(Status.values);
}
