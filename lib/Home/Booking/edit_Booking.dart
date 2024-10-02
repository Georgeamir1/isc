import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import 'Booking_list.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class EditBooking extends StatelessWidget {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final TextEditingController PatientCodeControler = TextEditingController();
  final TextEditingController ContactControler = TextEditingController();
  final ValueNotifier<DateTime> dateNotifier =
  ValueNotifier<DateTime>(DateTime.now());
  final BoardDateTimeController dateTimeController = BoardDateTimeController();
  bool isSelected = false;
  String? SelectedContact;

  EditBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to changes in dateNotifier and update the Date variable
    dateNotifier.addListener(() {
      final dateString =
      BoardDateFormat('yyyy/MM/dd h:mm a').format(dateNotifier.value);
      final formatter = DateFormat('yyyy/MM/dd h:mm a');
      final dateTime = formatter.parse(dateString);
      final hour = dateTime.hour;

      String dayType = hour >= 6 && hour < 12 ? 'Morning' : 'Night';
      // Update Date and DayType variables
      Date = dateString;
      DayType = dayType;
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getpatientDataCubit()),
        BlocProvider(
            create: (BuildContext context) => BookingCubit()..getBookindata()),
        BlocProvider(
            create: (BuildContext context) => getContactDataCubit()..getdata()),
      ],
      child: BlocConsumer<getpatientDataCubit, getpatientDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          return  Directionality(
            textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr, // Set text direction
            child: WillPopScope(
              onWillPop: () => _onWillPop(context),
              child: Scaffold(
                backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                resizeToAvoidBottomInset: true,
                appBar: CustomAppBar(title: isArabicsaved ? 'تعديل' : 'Edit'),
                body: SingleChildScrollView(

                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(

                            isArabicsaved ? ' كود المريض:  ' : 'Patient code: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,
                                color: isDarkmodesaved ? Colors.white : Colors.black54),
                          ),
                          Expanded(
                            child: CustomwhiteContainer(
                              Radius: 12,
                              child: ReusableTextFormField(
                                textStyle: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54),
                                controller: PatientCodeControler,
                                onChanged: (value) {
                                  getpatientDataCubit.get(context).updatePatientCode(value);
                                },
                                hintText: isArabicsaved ? 'أدخل كود المريض' : 'Enter patient code',

                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<BookingCubit, Bookingtatus>(
                        builder: (context, state) {
                          return CustomwhiteContainer(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ConditionalBuilder(
                                condition: state is! getpatientDataLoadingState,
                                builder: (context) => Text(
                                  '${patientname}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkmodesaved ? Colors.white : Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                fallback: (context) =>
                                const LinearProgressIndicator(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<BookingCubit, Bookingtatus>(
                        builder: (context, state) {
                          return CustomwhiteContainer(
                            child: CustomDateTimePickerFromVariable(
                              pickerType: DateTimePickerType.datetime,
                              dateNotifier: dateNotifier,
                              controller: dateTimeController,
                              initialDate: initialDate2,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            isArabicsaved ? 'جهة الاتصال:' : 'Contact:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,
                                color: isDarkmodesaved ? Colors.white : Colors.black54),
                          ),
                          Expanded(
                            child: CustomwhiteContainer(
                              child: BlocBuilder<getContactDataCubit, getContactDataStates>(
                                builder: (context, state) {
                                  final cubit = getContactDataCubit.get(context);
                                  return DropdownSearch<String>(
                                    items: cubit.Contacts,
                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        hintText: Contact == "null" ? (isArabicsaved ? "اختر جهة الاتصال" : "Choose contact") : "$Contact ",
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDarkmodesaved ? Colors.white : Colors.black54),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                                        ),
                                      ),
                                    ),
                                    selectedItem: SelectedContact,
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          hintText: isArabicsaved ? 'ابحث...' : 'Search...',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                                        ),
                                      ),
                                      itemBuilder: (context, item, isSelected) =>
                                          ListTile(
                                            title: Text(item),
                                            selected: isSelected,
                                          ),
                                    ),
                                    filterFn: (item, filter) => item
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        cubit.selectUser(newValue);
                                        Contact = Contact;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<BookingCubit, Bookingtatus>(
                        builder: (context, state) {
                          isSelected = (state is Bookingswitchstate) ? state.isSelected : false;
                          return CustomwhiteContainer(
                            height: 55,
                            child: SwitchListTile(
                              activeTrackColor: isDarkmodesaved ? Colors.deepPurple : Colors.indigoAccent,
                              title: Text(
                                New ? (isArabicsaved ? 'إعادة الحجز' : 'Rereserve') : (isArabicsaved ? 'حجز جديد' : 'New Reservation'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkmodesaved ? Colors.white : Colors.black54),
                              ),
                              value: New,
                              onChanged: (value) {
                                BookingCubit.get(context).edittoogel();
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(4, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                BookingCubit.get(context).Deletbookoing();
                                navigateToPage(context, BookingList());
                              },
                              child: Text(
                                isArabicsaved ? 'حذف' : 'Delete',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(4, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                print(Date);
                                BookingCubit.get(context).editBookin(
                                  time: Date,
                                  DayType: DayType,
                                  name: '$patientname',
                                  again: New,
                                  patcode: patientcode,
                                  No: selectedNo,
                                  Contact: Contact,
                                );
                                Contact = null;
                                navigateToPage(context, BookingList());
                              },
                              child: Text(
                                isArabicsaved ? 'تحديث' : 'Update',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pop(context);
    return true;
  }
}