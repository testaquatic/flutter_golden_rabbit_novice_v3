import 'package:calendar_scheduler/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;

  /// 텍스트 필드
  const CustomTextField({super.key, required this.label, required this.isTime});

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
          flex: isTime ? 0 : 1,
          child: TextFormField(
            cursorColor: Colors.grey,
            maxLines: isTime ? 1 : null,
            expands: !isTime,
            keyboardType: isTime
                ? TextInputType.number
                : TextInputType.multiline,
            inputFormatters: [
              if (isTime) FilteringTextInputFormatter.digitsOnly,
            ],
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

@Preview(
  name: 'CustomTextField - not Time',
  group: "component",
  size: Size.fromWidth(400),
)
Widget previewCustomTextFieldText() =>
    const CustomTextField(label: "not Time", isTime: false);

@Preview(
  name: 'CustomTextField - Time',
  group: "component",
  size: Size.fromWidth(400),
)
Widget previewCustomTextFieldTime() =>
    const CustomTextField(label: "Time", isTime: true);
