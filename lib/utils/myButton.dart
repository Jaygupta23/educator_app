import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appColors.dart';

class MyButton extends StatefulWidget {
  final void Function()? onPressed;
  final String text;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      height: 50.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.colorInfo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: Center(
              child: widget.text == ""
                  ? CircularProgressIndicator(
                      color: AppColors.colorSecondaryDarkest,
                    )
                  : Text(
                      widget.text,
                      style: TextStyle(
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
        ),
      ),
    );
  }
}
