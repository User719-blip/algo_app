import 'package:algorythm_app/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const SectionContainer({
    required this.child,
    this.padding = const EdgeInsets.all(28),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sectionSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.sectionStroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 18),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
