/// 채팅 메시지
class MessageModel {
  final int? id;
  final bool isMine;
  final String message;
  final int? point;
  final DateTime date;

  MessageModel({
    this.id,
    required this.isMine,
    required this.message,
    this.point,
    required this.date,
  });
}
