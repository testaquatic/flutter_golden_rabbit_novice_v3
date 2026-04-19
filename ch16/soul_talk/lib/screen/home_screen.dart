import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soul_talk/component/chat_test_field.dart';
import 'package:soul_talk/component/date_divider.dart';
import 'package:soul_talk/component/logo.dart';
import 'package:soul_talk/component/message.dart';
import 'package:soul_talk/model/message_model.dart';
import 'package:soul_talk/provider/message_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final controller = TextEditingController();
  // 로딩 여부를 확인하는 함수
  bool isRunning = false;
  // 오류 메시지
  String? error;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messagesStream = ref.watch(messageNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 메시지 리스트
            Expanded(
              child: switch (messagesStream) {
                AsyncValue(:final value, hasValue: true) => Builder(
                  builder: (context) {
                    final messages = value ?? [];
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => scrollToBottom(),
                    );
                    return buildMessageList(messages);
                  },
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
            // 텍스트 입력
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 32.0,
              ),
              child: ChatTextField(
                controller: controller,
                error: error,
                isLoading: isRunning,
                onSend: handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void handleSendMessage() async {
    final currentPrompt = controller.text;
    // 내가 보낸 메시지의 ID
    int? currentUserMessageId;

    // 입력된 메시지가 없을 경우에 오류를 표시한다.
    if (currentPrompt.isEmpty) {
      setState(() {
        error = "메시지를 입력해주세요!";
      });
      return;
    }

    final messageNotifier = ref.read(messageNotifierProvider.notifier);

    try {
      setState(() {
        isRunning = true;
      });
      controller.clear();

      final myMessageCount = await messageNotifier.db.countMyMessage();
      currentUserMessageId = await messageNotifier.saveMessage(
        MessageModel(
          isMine: true,
          message: currentPrompt,
          date: DateTime.now(),
          point: myMessageCount! + 1,
        ),
      );

      final contextMessages = await messageNotifier.db.getMessages(limit: 5);

      messageNotifier.sendMessage(
        contextMessages: contextMessages,
        onDone: () => setState(() {
          isRunning = false;
        }),
        onError: (e) {
          messageNotifier.deleteMessage(currentUserMessageId!);
          setState(() async {
            isRunning = false;
            error = e.toString();
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  /// 마법의 구슬이 들어간 로고
  Widget buildLogo() {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 16.0),
      child: Padding(padding: EdgeInsets.only(bottom: 60.0), child: Logo()),
    );
  }

  /// 개별 메시지를 표시한다.
  Widget buildMessageItem({
    MessageModel? prevMessage,
    required MessageModel message,
    required int index,
  }) {
    final isMine = message.isMine;
    // 날짜는 첫번째 메시지이거나 다음 메시지가 자정이 지났을 때 표시한다.
    final shouldDrawDateDivider =
        prevMessage == null || shouldDrawDate(prevMessage.date, message.date);

    return Column(
      children: [
        // 날짜를 표시해야 할지 확인하고, 조건에 따라서 표시한다.
        if (shouldDrawDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DateDivider(date: message.date),
          ),
        // 메시지
        Padding(
          padding: EdgeInsetsGeometry.only(
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

  /// 로고와 메시지들을 보여주는 위젯
  Widget buildMessageList(List<MessageModel> messages) {
    return ListView.separated(
      controller: scrollController,
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        // 첫번째로 로고를 표시한다.
        if (index == 0) {
          return buildLogo();
        }
        return buildMessageItem(
          message: messages[index - 1],
          prevMessage: index > 1 ? messages[index - 2] : null,
          index: index,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
    );
  }
}

/// 날짜가 다를 경우에 true를 반환하는 함수
bool shouldDrawDate(DateTime date1, DateTime date2) =>
    date1.day != date2.day ||
    date1.month != date2.month ||
    date1.year != date2.year;

/// 2026-04-16을 "2026년 4월 16일"형태로 표시하는 함수
String getStringDate(DateTime date) =>
    "${date.year}년 ${date.month}월 ${date.day}일";

/// 프리뷰용 함수
@Preview(name: "HomeScreen", group: "pages", brightness: Brightness.light)
Widget previewHomeScreeen() {
  return MaterialApp(home: HomeScreen());
}

/// 테스트를 위한 샘플 데이터
final sampleData = [
  MessageModel(
    id: 1,
    isMine: true,
    message: "오늘 저녁으로 먹을 만한 메뉴 추천해줘!",
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
