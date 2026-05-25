import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String selectedLanguage = 'id'; // 'id' untuk Indonesia, 'en' untuk English

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(
          'Ganti Bahasa',
          style: AppTextStyles.h1.copyWith(color: AppColors.primary),
        ),
      ),
      body: Column(
        children: [
          _buildLanguageItem(
            title: 'Bahasa Indonesia',
            value: 'id',
          ),
          _buildLanguageItem(
            title: 'English',
            value: 'en',
            hideBorder: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({required String title, required String value, bool hideBorder = false}) {
    final isSelected = selectedLanguage == value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: hideBorder 
              ? null 
              : const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}