import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  /// 선택한 날짜
  final DateTime selectedDate;

  /// 일정 입력을 받는 위젯
  const ScheduleBottomSheet({super.key, required this.selectedDate});

  @override
  State<ScheduleBottomSheet> createState() {
    return _ScheduleBottomSheetState();
  }
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  // 폼 키
  final _formKey = GlobalKey<FormState>();

  /// 시작 시간
  late int startTime;

  /// 종료 시간
  late int endTime;

  /// 일정 내용
  late String content;

  @override
  Widget build(BuildContext context) {
    /// 키보드 높이
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: _formKey,
      child: SafeArea(
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
                      child: CustomTextField(
                        label: "시작시간",
                        isTimeField: true,
                        onSaved: (val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // 종료시간
                    Expanded(
                      child: CustomTextField(
                        label: "종료시간",
                        isTimeField: true,
                        onSaved: (val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // 내용
                Expanded(
                  child: CustomTextField(
                    label: "내용",
                    isTimeField: false,
                    onSaved: (val) {
                      content = val!;
                    },
                    validator: contentValidator,
                  ),
                ),
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
      ),
    );
  }

  void onSavedPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          startTime: Value(startTime),
          endTime: Value(endTime),
          content: Value(content),
          date: Value(widget.selectedDate),
        ),
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  /// 시간 검증 함수
  String? timeValidator(String? val) {
    if (val == null) {
      return "값을 입력해주세요";
    }

    late int number;

    try {
      number = int.parse(val);
    } catch (e) {
      return "숫자를 입력해주세요";
    }

    if (number < 0 || number > 24) {
      return "0시부터 24시 사이를 입력해주세요";
    }

    return null;
  }

  /// 내용 검증 함수
  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "값을 입력해주세요";
    }

    return null;
  }
}
