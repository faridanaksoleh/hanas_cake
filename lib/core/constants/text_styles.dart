import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle display = TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 28, fontWeight: FontWeight.w500, height: 1.2, color: AppColors.textPrimary);
  static const TextStyle h1 = TextStyle(fontFamily: 'DMSans', fontSize: 22, fontWeight: FontWeight.w500, height: 1.3, color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(fontFamily: 'DMSans', fontSize: 18, fontWeight: FontWeight.w500, height: 1.3, color: AppColors.textPrimary);
  static const TextStyle h3 = TextStyle(fontFamily: 'DMSans', fontSize: 15, fontWeight: FontWeight.w500, height: 1.4, color: AppColors.textPrimary);
  static const TextStyle body = TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w400, height: 1.6, color: AppColors.textPrimary);
  static const TextStyle bodySmall = TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static const TextStyle caption = TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w400, height: 1.4, color: AppColors.textSecondary);
  static const TextStyle micro = TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w500, height: 1.3, color: AppColors.textSecondary);
}
