import 'package:flutter/material.dart';
import 'package:mbl/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;

  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.onSaved,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: renderTextField(),
        ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      // null이 return 되면 에러가 없다.
      // 에러가 있으면 에러를 String 값으로 리턴해준다.
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '내용을 입력해주세요';
        }

        if (val.length > 500) {
          return '500자 이하의 내용을 입력해주세요.';
        }

        return null;
      },
      cursorColor: Colors.grey,
      maxLines: null,
      expands: true,
      initialValue: initialValue,
      keyboardType: TextInputType.multiline,
      inputFormatters: [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: null,
      ),
    );
  }
}
