import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/Booking/Booking_list.dart';
import 'package:isc/Home/home/Medical Records.dart';
import 'package:isc/Home/home/Setting.dart';
import 'package:isc/State_manage/States/States.dart';
import 'package:isc/shared/Data.dart';

import '../../State_manage/Cubits/cubit.dart';
import '../../shared/componants.dart';
import 'BaicData.dart';

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // Check if the language is Arabic to handle text and direction
    bool isArabic = isArabicsaved;

    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            // Set text direction based on the selected language
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: WillPopScope(
              onWillPop: () async {
                bool shouldExit = await _showExitConfirmationDialog(context);
                return shouldExit;
              },
              child: Scaffold(
                backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                appBar: CustomAppBar(
                  title: isArabic ? 'الرئيسيه' : 'Home',
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          navigateToPage(context, Setting());
                        },
                        icon: Icon(Icons.settings, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                          child: Row(
                            children: [
                              Screens(
                                screenname: isArabic ? 'الحجوزات' : 'Reservations',
                                onPressed: () {
                                  navigateToPage(context, BookingList());
                                },
                                imagepath: isDarkmodesaved
                                    ? 'assets/images/schedual dark.png'
                                    : 'assets/images/schedule.png',
                              ),
                              SizedBox(width: 18),
                              Screens(
                                screenname: isArabic ? 'السجلات الطبية' : 'Medical Records',
                                onPressed: () {
                                  navigateToPage(context, MedicalRecords());
                                },
                                imagepath: isDarkmodesaved
                                    ? 'assets/images/medical records dark.png'
                                    : 'assets/images/medical records.png',
                              ),
                              SizedBox(width: 18),
                              Screens(
                                screenname: isArabic ? 'البيانات الأساسية' : 'Basic Data',
                                onPressed: () {
                                  navigateToPage(context, Basicdata());
                                },
                                imagepath: isDarkmodesaved
                                    ? 'assets/images/BasicDataDark21.png'
                                    : 'assets/images/BasicDataLight21.png',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  bool isArabic = isArabicsaved;
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isArabic ? 'خروج من التطبيق' : 'Exit App'),
      content: Text(isArabic ? 'هل أنت متأكد أنك تريد الخروج من التطبيق؟' : 'Are you sure you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(isArabic ? 'لا' : 'No'),
        ),
        TextButton(
          onPressed: () => exit(0),
          child: Text(isArabic ? 'نعم' : 'Yes'),
        ),
      ],
    ),
  ) ?? false;
}
