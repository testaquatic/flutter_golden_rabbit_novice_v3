import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  /// 텍스트 필드 제목
  final String label;

  /// 시간을 선택하는 필드일 경우에 true
  final bool isTimeField;

  /// 폼을 저장했을 때 실행하는 콜백
  final FormFieldSetter<String> onSaved;

  /// 폼을 검증할 때 실행하는 콜백
  final FormFieldValidator<String> validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.isTimeField,
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
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        ),
        Expanded(
          flex: isTimeField ? 0 : 1,
          child: TextFormField(
            onSaved: onSaved,
            validator: validator,
            cursorColor: Colors.grey,
            maxLines: isTimeField ? 1 : null,
            expands: !isTimeField,
            keyboardType: isTimeField
                ? TextInputType.number
                : TextInputType.multiline,
            inputFormatters: isTimeField
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              suffixText: isTimeField ? "시" : null,
            ),
          ),
        ),
      ],
    );
  }
}
