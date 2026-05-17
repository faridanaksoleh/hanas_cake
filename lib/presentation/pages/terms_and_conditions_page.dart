import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.caretLeft,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
            onPressed: () {
              if (GoRouter.of(context).canPop()) GoRouter.of(context).pop();
            },
          ),
        ),
        title: Text(
          'Syarat-syarat dan Ketentuan',
          style: AppTextStyles.display.copyWith(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // 🔥 Ini margin leganya biar nggak nempel ke layar
        padding: const EdgeInsets.all(24.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teks',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(16),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Tempus et non arcu ac feugiat facilisi dolor quam. Vel et lectus enim donec natoque ut. Pulvinar metus sapien ultrices ipsum natoque. Eleifend urna vel vehicula risus consequat in magna arcu sapien. Tempus tristique lacus mollis magna egestas suspendisse ut. Viverra odio nisl est viverra sit nunc massa id sed.\n\nFacilisis adipiscing nunc quisque potenti egestas ornare enim massa non. Sit senectus orci neque in pharetra mauris. Pellentesque commodo porta at senectus morbi. Massa rhoncus scelerisque massa amet sit nulla.\n\nProin orci mattis ac velit. Ullamcorper integer ultrices maecenas sit. Tempor volutpat at eu tortor mattis in ornare. Dui ut sollicitudin enim proin dapibus nibh est. Faucibus quis odio in ullamcorper hendrerit molestie magna. Tellus massa tortor et duis nec fringilla arcu id elit. Nec cras tortor turpis scelerisque vitae amet.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6, // 🔥 Line-height biar paragrafnya rapi dan enak dibaca
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}