import 'package:ch17_calendar_scheduler/component/custom_text_field.dart';
import 'package:ch17_calendar_scheduler/const/colors.dart';
import 'package:ch17_calendar_scheduler/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({required this.selectedDate, super.key});

  @override
  State<ScheduleBottomSheet> createState() {
    return _ScheduleBottomSheetState();
  }
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    // 키보드의 높이
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
          // 화면 반 높이에 키보드 높이만큼 추가한다.
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "시작 시간",
                        isTime: true,
                        onSaved: (val) {
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
                        onSaved: (val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: "내용",
                    isTime: false,
                    onSaved: (val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSavePressed(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: PRIMARY_COLOR,
                    ),
                    child: Text("저장"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return "값을 입력해주세요";
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return "숫자를 입력해주세요";
    }

    if (number < 0 || number > 24) {
      return "0시부터 24시까지 입력해주세요";
    }

    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "값을 입력해주세요";
    }

    return null;
  }

  void onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // 스케줄 모델 생성
      final schedule = ScheduleModel(
        id: Uuid().v4(),
        content: content!,
        date: widget.selectedDate,
        startTime: startTime!,
        endTime: endTime!,
      );

      // 파이어 스토어에 삽입
      await FirebaseFirestore.instance
          .collection("schedule")
          .doc(schedule.id)
          .set(schedule.toJson());

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
