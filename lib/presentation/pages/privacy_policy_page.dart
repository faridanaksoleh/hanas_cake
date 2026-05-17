import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Kebijakan Privasi - Hana\'s Bakery',
          style: AppTextStyles.display.copyWith(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
              'Id tempor et et feugiat. Nunc sodales dictum dui sit lobortis pellentesque lectus. Morbi tellus rhoncus sem nisl nisl ullamcorper.\n\nLorem sed pharetra mattis massa eget velit feugiat. Quam dui non leo sed. Ut aliquam massa arcu amet amet in volutpat purus sapien. Ultricies diam sit pretium cursus arcu. Ante diam mattis enim lectus orci ac ornare. Dictum ac lectus non ut et amet consectetur. Ante vitae at etiam nisl amet sed interdum commodo libero. Nec nulla pretium lorem ut lectus duis posuere amet etiam. Congue arcu dui vel quis sed porttitor non tortor tellus. Tempor lectus eget amet ligula amet mi vestibulum.\n\nSed sed accumsan pellentesque cras at. Non interdum platea ullamcorper semper. Fringilla scelerisque eget risus faucibus nibh volutpat nunc non. Convallis malesuada maecenas magna feugiat. Orci nunc lacus consectetur proin sit condimentum enim molestie mauris. Pulvinar tincidunt sed tincidunt porta eleifend interdum nisi tristique non.\n\nGravida ut lectus vitae cursus quam eu fames amet id. Aliquet phasellus scelerisque pellentesque molestie fringilla mattis. Adipiscing facilisis odio lacinia vel.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
