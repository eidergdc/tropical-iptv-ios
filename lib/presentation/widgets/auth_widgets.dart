import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';

class CardTallButton extends StatelessWidget {
  const CardTallButton({
    super.key,
    required this.label,
    required this.onTap,
    this.radius = 12,
    this.isLoading = false,
  });

  final String label;
  final Function() onTap;
  final double radius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        width: 100.w,
        height: 56,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: kColorPrimary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return kColorPrimary.withOpacity(0.6);
              }
              return kColorPrimary;
            }),
            foregroundColor: WidgetStateProperty.all(kColorTextBlack),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          child: isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: kColorTextBlack,
                  size: 35,
                )
              : Text(
                  label,
                  style: Get.textTheme.titleLarge!.copyWith(
                    color: kColorTextBlack,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}

class TropicalTextField extends StatefulWidget {
  const TropicalTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  State<TropicalTextField> createState() => _TropicalTextFieldState();
}

class _TropicalTextFieldState extends State<TropicalTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: kColorPrimary.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          style: Get.textTheme.bodyLarge!.copyWith(
            color: kColorText,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Get.textTheme.bodyMedium!.copyWith(
              color: kColorTextTertiary,
              fontSize: 14.sp,
            ),
            suffixIcon: Icon(
              widget.icon,
              size: 20,
              color: _isFocused ? kColorPrimary : kColorTextTertiary,
            ),
            filled: true,
            fillColor: kColorElevated1,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: kColorBorder,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: kColorBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: kColorPrimary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: kColorError,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: kColorError,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
