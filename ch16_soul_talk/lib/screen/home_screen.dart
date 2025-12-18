import 'package:ch16_soul_talk/component/chat_text_field.dart';
import 'package:ch16_soul_talk/component/date_divider.dart';
import 'package:ch16_soul_talk/component/logo.dart';
import 'package:ch16_soul_talk/component/message.dart';
import 'package:ch16_soul_talk/model/message_model.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

final sampleData = [
  MessageModel(
    id: 1,
    isMine: true,
    message: "오늘 저녁으로 먹을 만한 메뉴 추천해줘!",
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
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isRunning = false;
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
                stream: GetIt.I<Isar>().messageModels.where().watch(
                  fireImmediately: true,
                ),
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    scrollToBottom();
                  });
                  return buildMessageList(messages);
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
                controller: controller,
                error: error,
                loading: isRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    // 현재 위치가 최대 스크롤 가능 위치가 아닌 때만 실행한다.
    if (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // 메시지 전송 버튼을 누르면 실행하는 함수
  void handleSendMessage() async {
    // TextField에 입력된 메시지가 없으면 오류
    if (controller.text.isEmpty) {
      setState(() {
        error = "메시지를 입력해주세요!";
      });
      return;
    }

    // 현재 응답 받고 있는 메시지 ID
    int? currentModelMessageId;

    // 내가 보낸 메시지의 ID
    int? currentUserMessageId;

    // Isar 인스턴스 가져오기
    final isar = GetIt.I.get<Isar>();

    // 텍스트 필드에 입력된 값
    final currentPrompt = controller.text;

    try {
      // 로딩 중으로 상태 변경
      setState(() {
        isRunning = true;
      });

      // 텍스트 필드에 입력된 값을 삭제한다.
      controller.clear();

      // 현재 데이터베이스에 저장되어 있는 내가 보낸 메시지 숫자 세기
      final myMessageCount = await isar.messageModels
          .filter()
          .isMineEqualTo(true)
          .count();

      // 내가 보낸 메시지를 Isar에 저장한다.
      currentUserMessageId = await isar.writeTxn(() async {
        return await isar.messageModels.put(
          MessageModel(
            isMine: true,
            message: currentPrompt,
            date: DateTime.now(),
            point: myMessageCount + 1,
          ),
        );
      });

      // 최근의 메시지 다섯개만 불러온다.
      final contextMessages = await isar.messageModels
          .where()
          .limit(5)
          .findAll();

      // 최근 메시지를 Content로 변경한다.
      final List<Content> promptContext = contextMessages
          .map(
            (e) => Content(e.isMine ? "user" : "model", [TextPart(e.message)]),
          )
          .toList();

      // 모델 인스턴스 생성
      final model = FirebaseAI.googleAI().generativeModel(
        model: "gemini-2.5-flash",
        systemInstruction: Content.system(
          "너는 이제부터 착하고 친절한 친구의 역할을 할 거야. 앞으로 채팅을 하면서  긍정적인 말만 할 수 있도록 해줘.",
        ),
      );

      // Stream으로 받는 메시지를 추적한다.
      String message = "";

      model
          .generateContentStream(promptContext)
          .listen(
            (event) async {
              if (event.text != null) {
                message += event.text!;
              }

              // message 변수를 기반으로 MessageModel을 생성한다.
              final MessageModel model = MessageModel(
                isMine: false,
                message: message,
                date: DateTime.now(),
              );

              // 이미 메시지를 추가한 적이 있다면 id 프로퍼티를 추가한다.
              if (currentModelMessageId != null) {
                model.id = currentModelMessageId!;
              }

              // 메시지를 저장하고 반환받은 ID 값을 currentModelMessageId에 저장한다.
              currentModelMessageId = await isar.writeTxn<int>(() async {
                return isar.messageModels.put(model);
              });
            },
            onDone: () => setState(() {
              isRunning = false;
            }),
            onError: (e) async {
              await isar.writeTxn(() async {
                return isar.messageModels.delete(currentUserMessageId!);
              });

              setState(() {
                isRunning = false;
                error = e.toString();
              });
            },
          );
    } catch (e) {
      if (context.mounted) {
        // 에러가 있는 경우에 표시한다.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Widget buildMessageList(List<MessageModel> messages) {
    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        return index == 0
            ? buildLogo()
            : buildMessageItem(
                message: messages[index - 1],
                prevMessage: index > 1 ? messages[index - 2] : null,
                index: index - 1,
              );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 16.0),
      itemCount: messages.length + 1,
    );
  }

  Widget buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Logo(),
      ),
    );
  }

  Widget buildMessageItem({
    MessageModel? prevMessage,
    required MessageModel message,
    required int index,
  }) {
    final isMine = message.isMine;
    final shouldDrawDateDivider =
        prevMessage == null || shouldDrawDate(prevMessage.date, message.date);

    return Column(
      children: [
        if (shouldDrawDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DateDivider(date: message.date),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: isMine ? 64.0 : 16.0,
            right: isMine ? 16.0 : 64.0,
          ),
          child: Message(
            alignLeft: !isMine,
            message: message.message.trim(),
            point: message.point,
          ),
        ),
      ],
    );
  }

  // 이쪽이 조금더 이해하기 쉬워 보인다.
  bool shouldDrawDate(DateTime date1, DateTime date2) {
    return date1.day != date2.day ||
        date1.month != date2.month ||
        date1.year != date2.year;
  }

  String getStringDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
