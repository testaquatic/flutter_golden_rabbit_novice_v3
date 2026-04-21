import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

/// 일정 입력 화면
/// 화면의 반절을 차지한다.
class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5 + bottomInset,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: bottomInset,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: const CustomTextField(label: "시작 시간", isTime: true),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: const CustomTextField(label: "종료 시간", isTime: true),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(child: CustomTextField(label: "내용", isTime: false)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSavePressed,

                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                  child: const Text("저장"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSavePressed() {}
}

@Preview(
  name: 'Schedule Bottom Sheet',
  group: "component",
  size: Size.fromWidth(400),
)
Widget previewScheduleBottomSheet() => const ScheduleBottomSheet();
