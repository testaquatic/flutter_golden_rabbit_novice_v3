import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:soul_talk/component/chat_text_field.dart';
import 'package:soul_talk/component/date_divider.dart';
import 'package:soul_talk/component/logo.dart';
import 'package:soul_talk/component/message.dart';
import 'package:soul_talk/model/message_model.dart';
import 'package:soul_talk/model/message_model_sqlite3.dart';

final sampleData = [
  MessageModel(
    id: 1,
    isMine: true,
    message: "오늘 저녁 먹을 만한 메뉴 추천해줘!",
    point: 1,
    date: DateTime(2024, 11, 23),
  ),
  MessageModel(
    id: 2,
    isMine: false,
    message: "칼칼한 김치찜은 어때요!?",
    date: DateTime(2024, 11, 23),
  ),
];

class HomeScreen extends StatefulWidget {
  /// 처음 띄우는 홈 스크린
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  /// 텍스트 필드 컨트롤러
  final TextEditingController _controller = TextEditingController();

  /// 코드 스크롤
  final _scrollController = ScrollController();

  /// 로딩 여부
  bool isRunning = false;

  /// 에러 메시지
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: GetIt.I<MessageModelSqlite3>().resultStream.stream,
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];

                  // 하단으로 스크롤하는 콜백
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) async => scrollToBottom(),
                  );

                  return _buildMessageList(messages);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 32.0,
              ),
              child: ChatTextField(
                onSend: handleSendMessage,
                controller: _controller,
                error: error,
                isLoading: isRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 하단으로 스크롤한다.
  void scrollToBottom() {
    if (_scrollController.position.pixels !=
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// 메시지 리스트를 표시한다.
  Widget _buildMessageList(List<MessageModel> messages) {
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        // 첫번째 아이템은 로고
        if (index == 0) {
          return _buildLogo();
        }

        // 나머지 아이템은 메시지
        return _buildMessageItem(
          message: messages[index - 1],
          prevMessage: index > 1 ? messages[index - 2] : null,
          index: index - 1,
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 16.0),
      itemCount: messages.length + 1,
    );
  }

  void handleSendMessage() async {
    if (_controller.text.isEmpty) {
      setState(() {
        error = "메시지를 입력해주세요!";
      });
      return;
    }

    /// 현재 응답받고 있는 메시지 ID
    int? currentModelMessageId;

    /// 내가 보낸 메시지 ID
    int? currentUserMessageId;

    final db = GetIt.I.get<MessageModelSqlite3>();

    // TestField에 입력된 값 가져오기
    final currentPrompt = _controller.text;

    try {
      setState(() {
        isRunning = true;
      });
      _controller.clear();

      final myMessageCount = db.countMine();

      // 내 메시지를 저장한다.
      currentUserMessageId = db.saveMessage(
        MessageModel(
          isMine: true,
          message: currentPrompt,
          point: myMessageCount + 1,
          date: DateTime.now(),
        ),
      );

      // 컨텍스트를 생성한다.
      final contextMessages = db.getMessages(5);

      final promptContext = contextMessages
          .map(
            (element) => Content(element.isMine ? "user" : "model", [
              TextPart(element.message),
            ]),
          )
          .toList();

      final model = FirebaseAI.googleAI().generativeModel(
        model: "gemini-2.5-flash",
        systemInstruction: Content.system(
          "너는 이제부터 착하고 친절한 친구의 역할을 할 거야. 앞으로 채팅을 하면서 긍정적인 말만 할 수 있도록 해줘.",
        ),
      );

      // 요청을 보낸다.
      String message = "";

      model
          .generateContentStream(promptContext)
          .listen(
            (event) async {
              if (event.text != null) {
                message += event.text!;
              }

              final model = MessageModel(
                id: currentModelMessageId,
                isMine: false,
                message: message,
                date: DateTime.now(),
              );

              currentModelMessageId = db.saveMessage(model);
            },
            onDone: () => setState(() {
              currentModelMessageId = null;
              isRunning = false;
            }),
            onError: (e) async {
              db.deleteMessage(currentUserMessageId!);
              setState(() {
                error = e.toString();
                isRunning = false;
              });
            },
          );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// 로고를 표시한다.
  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Logo(),
    );
  }

  /// 메시지를 표시한다.
  Widget _buildMessageItem({
    MessageModel? prevMessage,
    required MessageModel message,
    required int index,
  }) {
    final shouldDrawDateDivider =
        prevMessage == null || shouldDrawDate(prevMessage.date, message.date);

    return Column(
      children: [
        // 날짜가 바뀌었을 때 날짜 표시
        if (shouldDrawDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DateDivider(date: message.date),
          ),
        // 메시지
        Padding(
          padding: EdgeInsets.only(
            left: message.isMine ? 64.0 : 16.0,
            right: message.isMine ? 16.0 : 64.0,
          ),
          child: Message(
            align: message.isMine ? MessageAlign.right : MessageAlign.left,
            message: message.message.trim(),
            point: message.point,
          ),
        ),
      ],
    );
  }

  /// 날짜가 다른 경우에 true를 반환
  bool shouldDrawDate(DateTime date1, DateTime date2) {
    return date1.year != date2.year ||
        date1.month != date2.month ||
        date1.day != date2.day;
  }
}
