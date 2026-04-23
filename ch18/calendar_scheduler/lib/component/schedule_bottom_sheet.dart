import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/consts/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 일정 입력 화면
/// 화면의 반절을 차지한다.
class ScheduleBottomSheet extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({super.key, required this.selectedDate});

  @override
  ConsumerState<ScheduleBottomSheet> createState() =>
      _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends ConsumerState<ScheduleBottomSheet> {
  final formKey = GlobalKey<FormState>();
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Form(
      key: formKey,
      child: SafeArea(
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
                      child: CustomTextField(
                        label: "시작 시간",
                        isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        label: "종료 시간",
                        isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: "내용",
                    isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
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
      ),
    );
  }

  void onSavePressed() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      await ref
          .read(scheduleNotifierProvider.notifier)
          .addSchedule(
            ScheduleModel(
              id: 0,
              content: content!,
              date: widget.selectedDate,
              startTime: startTime!,
              endTime: endTime!,
            ),
          );

      if (mounted) {
        context.pop();
      }
    }
  }

  String? timeValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "값을 입력해주세요";
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return "숫자를 입력해주세요";
    }

    if (number < 0 || number > 24) {
      return "0 부터 24 사이의 숫자를 입력해주세요";
    }

    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "값을 입력해주세요";
    }

    return null;
  }
}

@Preview(
  name: 'Schedule Bottom Sheet',
  group: "component",
  size: Size.fromWidth(400),
)
Widget previewScheduleBottomSheet() =>
    ScheduleBottomSheet(selectedDate: DateTime.now());
