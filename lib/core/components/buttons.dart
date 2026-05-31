import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final BorderSide? border;
  final double height;
  final double radius;

  const AppButton._({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.border,
    this.height = 48,
    this.radius = 12,
  });

  factory AppButton.primary({required String text, VoidCallback? onPressed}) {
    return AppButton._(text: text, onPressed: onPressed, backgroundColor: AppColors.primary, textColor: Colors.white);
  }

  factory AppButton.secondary({required String text, VoidCallback? onPressed}) {
    return AppButton._(text: text, onPressed: onPressed, backgroundColor: AppColors.secondary, textColor: Colors.white);
  }

  factory AppButton.outline({required String text, VoidCallback? onPressed}) {
    return AppButton._(text: text, onPressed: onPressed, backgroundColor: Colors.transparent, textColor: AppColors.primary, border: const BorderSide(color: AppColors.primary, width: 1.5), height: 44);
  }

  factory AppButton.danger({required String text, VoidCallback? onPressed}) {
    return AppButton._(text: text, onPressed: onPressed, backgroundColor: AppColors.dangerBg, textColor: AppColors.dangerText, height: 44, radius: 10);
  }

  factory AppButton.logout({required String text, VoidCallback? onPressed}) {
    return AppButton._(text: text, onPressed: onPressed, backgroundColor: Colors.red, textColor: Colors.white, height: 52, radius: 0);
  }

  factory AppButton.disabled({required String text}) {
    return AppButton._(text: text, onPressed: null, backgroundColor: AppColors.border, textColor: AppColors.textSecondary, height: 44, radius: 10);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: border != null ? Border.fromBorderSide(border!) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(color: textColor),
        ),
      ),
    );
  }
}
