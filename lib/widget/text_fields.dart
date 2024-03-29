import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  String? defaultText; // 기본적으로 미리 쓰여지는 텍스트 값
  String? hintText; // 입력에 힌트가 되는 텍스트 설정 값
  bool isPasswordField = false; // 비밀번호 입력필드 인지 여부
  bool? isEnabled; // 텍스트 필드 활성화 여부
  int? maxLines; // 최대 텍스트 줄 길이
  bool isReadOnly; // 읽기 전용 입력필드인지 여부
  TextInputType keyboardType; // 키보드 입력 타입
  TextInputAction textInputAction; // 키보드 액션 타입
  FormFieldValidator validator; // 유효성 검사
  TextEditingController controller;
  Function(String value)? onFieldSubmitted; // 키보드에서 액션 결과 값을 받는 콜백
  Function()? onTap;

  TextFormFieldCustom({
    this.defaultText,
    this.hintText,
    required this.isPasswordField,
    this.isEnabled,
    this.maxLines,
    required this.isReadOnly,
    required this.keyboardType,
    required this.textInputAction,
    required this.validator,
    required this.controller,
    this.onFieldSubmitted,
    this.onTap,
    super.key,
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.defaultText,
      validator: (value) => widget.validator(value),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.isEnabled,
      readOnly: widget.isReadOnly,
      onTap: widget.isReadOnly ? widget.onTap : null,
      maxLines: widget.maxLines,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        hintText: widget.hintText,
      ),
      obscureText: widget.isPasswordField,
    );
  }
}
