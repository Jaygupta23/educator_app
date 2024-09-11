import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

enum SingingCharacter { us, uk }

enum LanguageCharacter { mandarin, spanish, hindi, french, arabic, bangla }

class LanguageScreenProfile extends StatefulWidget {
  const LanguageScreenProfile({super.key});

  @override
  State<LanguageScreenProfile> createState() => _LanguageScreenProfileState();
}

class _LanguageScreenProfileState extends State<LanguageScreenProfile> {
  late SingingCharacter? _character = SingingCharacter.us;
  late LanguageCharacter? _character2 = LanguageCharacter.bangla;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text(
          'Language',
          style: TextStyle(color: AppColors.colorSecondaryLight),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.colorSecondaryLight,
          onPressed: () {
            Get.back(); // This will navigate back using GetX
          },
        ),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.colorWhiteHighEmp,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'English (US)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<SingingCharacter>(
                  value: SingingCharacter.us,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'English (UK)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<SingingCharacter>(
                  value: SingingCharacter.uk,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Language',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.colorWhiteHighEmp,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'Mandarin',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<LanguageCharacter>(
                  value: LanguageCharacter.bangla,
                  groupValue: _character2,
                  onChanged: (LanguageCharacter? value) {
                    setState(() {
                      _character2 = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'Spanish',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<LanguageCharacter>(
                  value: LanguageCharacter.spanish,
                  groupValue: _character2,
                  onChanged: (LanguageCharacter? value) {
                    setState(() {
                      _character2 = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'Hindi',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<LanguageCharacter>(
                  value: LanguageCharacter.hindi,
                  groupValue: _character2,
                  onChanged: (LanguageCharacter? value) {
                    setState(() {
                      _character2 = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'French',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<LanguageCharacter>(
                  value: LanguageCharacter.french,
                  groupValue: _character2,
                  onChanged: (LanguageCharacter? value) {
                    setState(() {
                      _character2 = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Text(
                  'Arabic',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: Radio<LanguageCharacter>(
                  value: LanguageCharacter.arabic,
                  groupValue: _character2,
                  onChanged: (LanguageCharacter? value) {
                    setState(() {
                      _character2 = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
