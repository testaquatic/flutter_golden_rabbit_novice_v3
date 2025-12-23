import 'package:ch17_calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  // 제목
  final String label;
  // 시간을 선택하는지 여부
  final bool isTime;
  // 폼을 저장했을 때 실행할 함수
  final FormFieldSetter<String> onSaved;
  // 폼을 검증했을 때 실행할 함수
  final FormFieldValidator<String> validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            onSaved: onSaved,
            validator: validator,
            cursorColor: Colors.grey,
            maxLines: isTime ? 1 : null,
            expands: !isTime,
            keyboardType: isTime
                ? TextInputType.number
                : TextInputType.multiline,
            inputFormatters: isTime
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              suffixText: isTime ? "시" : null,
            ),
          ),
        ),
      ],
    );
  }
}
