import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/Booking/Booking_New.dart';
import 'package:isc/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import 'Booking_list.dart'; // Ensure this import is present

class NewPatient extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController PatientNameControler = TextEditingController();
  final TextEditingController PatientNIDControler = TextEditingController();
  final TextEditingController PatientPhoneControler = TextEditingController();
  final TextEditingController PatientAddressControler = TextEditingController();
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final BoardDateTimeController dateTimeController = BoardDateTimeController();
  final _formKey = GlobalKey<FormState>(); // Form key
  bool isSelected = false;

  int? code;
  NewPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to changes in dateNotifier and update the Date variable
    dateNotifier.addListener(() {
      final dateTime = dateNotifier.value;

      if (dateTime != null) {
        final dateString = BoardDateFormat('yyyy/MM/dd h:mm a').format(dateTime);
        final hour = dateTime.hour;
        String dayType = hour >= 6 && hour < 12 ? 'Morning' : 'Night';

        // Update Date and DayType variables
        Date = dateString;
        DayType = dayType;
      }
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getpatientDataCubit()..getpatientsdata()),
        BlocProvider(create: (BuildContext context) => BookingCubit())
      ],
      child: BlocConsumer<getpatientDataCubit, getpatientDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBar(
                title: isArabicsaved ? 'مريض جديد' : 'New Patient',
              ),
              body: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey, // Assign form key
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ReusableTextFormField(
                              maxLenght: 250,
                              controller: PatientNameControler,
                              onChanged: (p0) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isArabicsaved ? 'الرجاء إدخال الاسم' : 'Please enter Name';
                                }
                              },
                              hintText: isArabicsaved ? 'اسم المريض' : 'Patient Name',
                            ),
                          ),
                          const SizedBox(width: 8),
                          BlocBuilder<getpatientDataCubit, getpatientDataStatus>(
                            builder: (context, state) {
                              code = getpatientDataCubit.get(context).patientlenth ?? 1;
                              return CustomwhiteContainer(
                                width: 48,
                                height: 48,
                                Radius: 12,
                                child: Center(
                                  child: Text(
                                    '$code',
                                    style: TextStyle(
                                      color: isDarkmodesaved ? Colors.white : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ReusableTextFormField(
                        maxLenght: 14,
                        keyboardType: TextInputType.number,
                        controller: PatientNIDControler,
                        onChanged: (p0) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabicsaved ? 'الرجاء إدخال الرقم القومي' : 'Please enter ID';
                          } else if (value.length != 14) {
                            return isArabicsaved ? 'يجب إدخال 14 رقمًا' : 'Please enter 14 digits';
                          }
                        },
                        hintText: isArabicsaved ? 'الرقم القومي' : 'National ID',
                      ),
                      const SizedBox(height: 24),
                      ReusableTextFormField(
                        maxLenght: 11,
                        keyboardType: TextInputType.number,
                        controller: PatientPhoneControler,
                        onChanged: (p0) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabicsaved ? 'الرجاء إدخال الهاتف' : 'Please enter Phone';
                          } else if (value.length != 11) {
                            return isArabicsaved ? 'يجب إدخال 11 رقمًا' : 'Please enter 11 digits';
                          }
                        },
                        hintText: isArabicsaved ? 'رقم الجوال' : 'Mobile Number',
                      ),
                      const SizedBox(height: 24),
                      ReusableTextFormField(
                        maxLenght: 400,
                        controller: PatientAddressControler,
                        onChanged: (p0) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabicsaved ? 'الرجاء إدخال العنوان' : 'Please enter Address';
                          }
                        },
                        hintText: isArabicsaved ? 'العنوان' : 'Address',
                      ),
                      const SizedBox(height: 24),
                      CustomwhiteContainer(
                        child: FormField<DateTime>(
                          validator: (value) {
                            if (value == null) {
                              return isArabicsaved ? 'الرجاء اختيار التاريخ' : 'Please select a date';
                            }
                            return null;
                          },
                          builder: (FormFieldState<DateTime> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDateTimePicker2(
                                  pickerType: DateTimePickerType.date,
                                  dateNotifier: dateNotifier,
                                  controller: dateTimeController,
                                  onDateChanged: (DateTime? newDateTime) {
                                    state.didChange(newDateTime);
                                    state.validate();
                                  },
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5, left: 13),
                                    child: Text(
                                      state.errorText ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFFbd0000),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<BookingCubit, Bookingtatus>(
                        builder: (context, state) {
                          isSelected = (state is Bookingswitchstate && state.isSelected);

                          return CustomwhiteContainer(
                            height: 60,
                            child: SwitchListTile(
                              activeTrackColor: Colors.indigoAccent,
                              title: Text(
                                isSelected ? (isArabicsaved ? 'ذكر' : 'Male') : (isArabicsaved ? 'أنثى' : 'Female'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.blueAccent : Colors.pinkAccent,
                                ),
                              ),
                              value: isSelected,
                              onChanged: (bool value) {
                                BookingCubit.get(context).toogel();
                              },
                              inactiveTrackColor: Colors.pinkAccent,
                              inactiveThumbColor: Colors.white,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      CustomblueContainer(
                        Radius: 30,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              getpatientDataCubit.get(context).NewPatient(
                                  PatientName: PatientNameControler.text,
                                  NationalID: PatientNIDControler.text,
                                  Phone: PatientPhoneControler.text,
                                  Address: PatientAddressControler.text,
                                  BirthDate: Date,
                                  Gender: isSelected,
                                  code: code);
                              navigateToPage(context, BookingList());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabicsaved?'تم الاضافه بنجاح':'Form Submitted Successfully',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              // Display error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabicsaved?'املاء الحقول الفارغه من فضلك':'Please fill in all required fields',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },


                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          label: Text(
                            isArabicsaved?'تاكيد':'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                      ),
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
