import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  /// 일정 입력을 받는 위젯
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() {
    return _ScheduleBottomSheetState();
  }
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    /// 키보드 높이
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2 + bottomInset,
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
              // 시간
              Row(
                children: [
                  // 시작시간
                  Expanded(
                    child: CustomTextField(label: "시작시간", isTimeField: true),
                  ),
                  const SizedBox(width: 16.0),
                  // 종료시간
                  Expanded(
                    child: CustomTextField(label: "종료시간", isTimeField: true),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              // 내용
              Expanded(child: CustomTextField(label: "내용", isTimeField: false)),
              // 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSavedPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text("저장"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSavedPressed() {}
}
