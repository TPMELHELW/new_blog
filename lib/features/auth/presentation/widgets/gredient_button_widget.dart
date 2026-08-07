import 'package:flutter/material.dart';
import 'package:new_blog_app/core/theme/app_pallete.dart';

class GredientButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const GredientButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
            // AppPallete.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          minimumSize: Size(100, 70),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(text, style: TextStyle(color: AppPallete.whiteColor)),
      ),
    );
  }
}
