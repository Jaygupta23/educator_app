import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';

class RememberMeModel extends StatefulWidget {
  const RememberMeModel({super.key});

  @override
  State<RememberMeModel> createState() => _RememberMeModelState();
}

class _RememberMeModelState extends State<RememberMeModel> {
  // Declare a boolean variable to hold the state of the checkbox.
  bool? check1 = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Add some padding to the left of the checkbox.
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 12, bottom: 12),
          child: Theme(
            // Change the color of the checkbox when it's unchecked.
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: AppColors.colorWhiteHighEmp,
            ),
            child: Transform.scale(
              scale: 0.9,
              child: SizedBox(
                height: 20.h,
                width: 20.w,
                child: Checkbox(
                    value: check1,
                    // When the state of the checkbox changes, update the value of check1.
                    onChanged: (bool? value) {
                      setState(() {
                        check1 = value;
                      });
                    }),
              ),
            ),
          ),
        ),
        // Add some padding to the left of the "Remember me" text.
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Remember me",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.colorWhiteHighEmp,
            ),
          ),
        )
      ],
    );
  }
}
