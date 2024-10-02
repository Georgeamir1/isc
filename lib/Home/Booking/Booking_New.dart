import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import 'Booking_list.dart'; // Ensure this import is present

class BookingNew extends StatelessWidget {
  final TextEditingController PatientCodeControler = TextEditingController();
  final TextEditingController ContactControler = TextEditingController();
  final ValueNotifier<DateTime> dateNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  final BoardDateTimeController dateTimeController = BoardDateTimeController();
  final _formKey = GlobalKey<FormState>(); // Form key
  bool isSelected = false;
  String? SelectedContact;

  BookingNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to changes in dateNotifier and update the Date variable
    dateNotifier.addListener(() {
      final dateTime = dateNotifier.value;

      if (dateTime != null) {
        final dateString =
            BoardDateFormat('yyyy/MM/dd h:mm a').format(dateTime);
        final hour = dateTime.hour;
        String dayType =
            hour >= 6 && hour < 12 ? 'صباحاً' : 'مساءً'; // Updated for Arabic

        // Update Date and DayType variables
        Date = dateString;
        DayType = dayType;
      }
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getpatientDataCubit()),
        BlocProvider(create: (BuildContext context) => BookingCubit()),
        BlocProvider(
            create: (BuildContext context) => getContactDataCubit()..getdata())
      ],
      child: BlocConsumer<getpatientDataCubit, getpatientDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              backgroundColor:
                  isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBar(
                  title: isArabicsaved ? 'حجز جديد' : 'New Reservation'),
              body: Directionality(
                textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr, // Set text direction
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey, // Assign form key
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              isArabicsaved ? 'كود المريض :' : 'Patient Code :',
                              // Localized text
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDarkmodesaved
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomwhiteContainer(
                                child: ReusableTextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: PatientCodeControler,
                                  hintText: isArabicsaved
                                      ? 'أدخل كود المريض'
                                      : 'Enter patient code',
                                  // Localized hint
                                  hintStyle: TextStyle(
                                      color: isDarkmodesaved
                                          ? Colors.white
                                          : Colors.black54),
                                  onChanged: (value) {
                                    getpatientDataCubit
                                        .get(context)
                                        .updatePatientCode(value);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return isArabicsaved
                                          ? 'يرجى إدخال كود المريض'
                                          : 'Please enter a patient code'; // Localized validation
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomwhiteContainer(
                          width: double.infinity,
                          height: 55,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ConditionalBuilder(
                              condition: state is! getpatientDataLoadingState,
                              builder: (context) => Text(
                                '${getpatientDataCubit.get(context).patientname2}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkmodesaved
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              fallback: (context) =>
                                  const LinearProgressIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomwhiteContainer(
                          width: double.infinity,
                          child: CustomDateTimePicker(
                            pickerType: DateTimePickerType.datetime,
                            dateNotifier: dateNotifier,
                            controller: dateTimeController,
                            onDateChanged: (DateTime? newDateTime) {
                              if (newDateTime != null) {
                                dateNotifier.value = newDateTime;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              isArabicsaved
                                  ? 'اسم جهة التعاقد :'
                                  : 'Contact Name :', // Localized text
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDarkmodesaved
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomwhiteContainer(
                                child: BlocBuilder<getContactDataCubit,
                                    getContactDataStates>(
                                  builder: (context, state) {
                                    final cubit =
                                        getContactDataCubit.get(context);

                                    return DropdownSearch<String>(
                                      items: cubit.Contacts,
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        baseStyle: TextStyle(
                                            color: isDarkmodesaved
                                                ? Colors.white
                                                : Colors.black45),
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                          hintText: isArabicsaved
                                              ? 'اختر جهة التعاقد'
                                              : 'Select Contact',
                                          // Localized hint
                                          hintStyle: TextStyle(
                                              color: isDarkmodesaved
                                                  ? Colors.white
                                                  : Colors.black54),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIconColor: isDarkmode
                                              ? Colors.white
                                              : Colors.black45,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2),
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            prefixIcon: Icon(Icons.search,
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                        itemBuilder:
                                            (context, item, isSelected) =>
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
                                          SelectedContact =
                                              newValue; // Update SelectedContact variable
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return isArabicsaved
                                              ? 'يرجى اختيار جهة الاتصال'
                                              : 'Please select a contact'; // Localized validation
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
                            isSelected = (state is Bookingswitchstate &&
                                state.isSelected);

                            return CustomwhiteContainer(
                              height: 55,
                              child: SwitchListTile(
                                activeTrackColor: isDarkmodesaved
                                    ? Colors.deepPurple
                                    : Colors.indigo,
                                title: Text(
                                  isSelected
                                      ? (isArabicsaved
                                          ? 'إعادة كشف'
                                          : 'Rereserve')
                                      : (isArabicsaved
                                          ? 'حجز جديد'
                                          : 'NEW'), // Localized text
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkmodesaved
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (bool value) {
                                  BookingCubit.get(context).toogel();
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomblueContainer(
                          width: double.infinity,
                          Radius: 30,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BookingCubit.get(context).newBookin(
                                  time: Date ?? '${DateTime.now()}',
                                  DayType: DayType,
                                  contact: SelectedContact,
                                  name:
                                      '${getpatientDataCubit.get(context).patientname2}',
                                  again: isSelected,
                                  patcode: PatientCodeControler.text,
                                  Contact: Contact,
                                  id_clinic: ClinicID,
                                );
                                Contact = null;
                                navigateToPage(context, BookingList());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Form Submitted Successfully',
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
                                      'Please fill in all required fields',
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
                              isArabicsaved ? 'حفظ' : 'Submit',
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
              ));
        },
      ),
    );
  }
}
