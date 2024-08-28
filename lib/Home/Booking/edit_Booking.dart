import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isc/Home/Booking/Booking_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart'; // Ensure this import is present

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
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()),
        BlocProvider(
            create: (BuildContext context) => getContactDataCubit()..getdata()),
      ],
      child: BlocConsumer<getpatientDataCubit, getpatientDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(72.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.lightBlue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'New Reservation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              getpatientDataCubit
                                  .get(context)
                                  .updatePatientCode(value);
                            },
                            controller: PatientCodeControler,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'ادخل كود المريض',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              alignLabelWithHint: true,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '  : كود المريض ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<BookingCubit, Bookingtatus>(
                      builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConditionalBuilder(
                          condition: state is! getpatientDataLoadingState,
                          builder: (context) => Text(
                            '${patientname}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                          fallback: (context) =>
                              const LinearProgressIndicator(),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  BlocBuilder<BookingCubit, Bookingtatus>(
                      builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomDateTimePickerFromVariable(
                        pickerType: DateTimePickerType.datetime,
                        dateNotifier: dateNotifier,
                        controller: dateTimeController,
                        initialDate: initialDate2,
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: BlocBuilder<getContactDataCubit,
                              getContactDataStates>(
                            builder: (context, state) {
                              final cubit = getContactDataCubit.get(context);
                              return DropdownSearch<String>(
                                items: cubit.Contacts,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  textAlign: TextAlign.center,
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    hintText: Contact == "null"
                                        ? "اختر تعاقد"
                                        : "$Contact ",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 2),
                                    ),
                                  ),
                                ),
                                selectedItem: SelectedContact,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.grey[600]),
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
                      const Text(
                        '  : اسم التعاقد ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<BookingCubit, Bookingtatus>(
                    builder: (context, state) {
                      isSelected = (state is Bookingswitchstate)
                          ? state.isSelected
                          : false;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SwitchListTile(
                          activeTrackColor: Colors.indigoAccent,
                          title: Text(
                            New ? 'إعادة كشف' : 'كشف جديد',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
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
                            'Delete',
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
                  const SizedBox(height: 100),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlue, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
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
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Submit',
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
          );
        },
      ),
    );
  }
}
