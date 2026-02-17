class MessageModel {
  /// 메시지 ID
  final int? id;

  /// 내가 보낸 메시지일 경우에 true
  final bool isMine;

  /// 메시지 본문
  final String message;

  // 포인트
  final int? point;

  /// 날짜
  final DateTime date;

  /// 메시지 인스턴스를 생성한다.
  MessageModel({
    this.id,
    required this.isMine,
    required this.message,
    required this.date,
    this.point,
  });
}
