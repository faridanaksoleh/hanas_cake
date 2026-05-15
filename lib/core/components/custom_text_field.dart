import 'package:flutter/material.dart';
import 'package:hanas_cake/core/core.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? suffixWidget;
  final Color? labelColor;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.hintText,
    this.keyboardType,
    this.maxLength,
    this.suffixWidget,
    this.labelColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.body.copyWith(
            color: widget.labelColor ?? AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          style: AppTextStyles.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            hintText: widget.hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.border,
            ),
            counterText: '', // Menghilangkan counter bawaan di bawah
            suffix: widget.suffixWidget ?? (
              widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                : (widget.maxLength != null)
                    ? Text(
                        '${widget.controller?.text.length ?? 0}/${widget.maxLength}',
                        style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary),
                      )
                    : null
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryLight),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryLight),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryLight),
            ),
          ),
          onChanged: (value) {
            if (widget.maxLength != null) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
