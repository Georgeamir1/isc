import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Screens/Booking/Booking_New.dart';
import 'package:isc/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../onboarding/test.dart';
import '../../shared/Data.dart'; // Ensure this import is present

class BookingNew extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
   TextEditingController PatientCodeControler = TextEditingController();
   TextEditingController ContactControler = TextEditingController();
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final BoardDateTimeController dateTimeController = BoardDateTimeController();
  bool isSelected = false;


  BookingNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to changes in dateNotifier and update the Date variable
    dateNotifier.addListener(() {
      final dateString = BoardDateFormat('yyyy/MM/dd h:mm a').format(dateNotifier.value);
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
        BlocProvider(create: (BuildContext context) => BookingCubit()),
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()),
        BlocProvider(create: (BuildContext context) => getContactDataCubit()..getdata())
      ],
      child: BlocConsumer<getpatientDataCubit, getpatientDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {

          return Scaffold(
            backgroundColor: Colors.grey[100],
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(72.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 4),
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
                    title: Text(
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
                      if(edit == true)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ConditionalBuilder(condition: state is !getDoctorDataLoadingState,
                          fallback:(context) => CircularProgressIndicator(),
                          builder: (context) => Text(' القديم \n${patientcode}',textAlign: TextAlign.center,),),
                        ),
                      ),
                    SizedBox(width: 8,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              getpatientDataCubit.get(context).updatePatientCode(value);
                            },
                            controller: PatientCodeControler,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              hintText: 'ادخل كود المريض',
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '  : كود المريض ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConditionalBuilder(
                        condition: state is! getpatientDataLoadingState,
                        builder: (context) => Text(
                          '${getpatientDataCubit.get(context).patientname}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        fallback: (context) => LinearProgressIndicator(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomDateTimePicker(
                      pickerType: DateTimePickerType.datetime,
                      dateNotifier: dateNotifier,
                      controller: dateTimeController,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child:   Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: BlocBuilder<getContactDataCubit, getContactDataStates>(
                            builder: (context, state) {
                              final cubit = getContactDataCubit.get(context);

                              return DropdownSearch<String>(
                                items: cubit.Contacts,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    hintText: "Select Contact",
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    filled: true,
                                    fillColor: Colors.white,
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
                                      hintText: 'Search...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                                    ),
                                  ),
                                  itemBuilder: (context, item, isSelected) => ListTile(
                                    title: Text(item),
                                    selected: isSelected,
                                  ),
                                ),
                                filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    cubit.selectUser(newValue);
                                  }
                                },
                              );
                            },
                          ),
                        )

                      ),
                      Text(
                        '  : اسم التعاقد ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  BlocBuilder<BookingCubit, Bookingtatus>(
                    builder: (context, state) {
                      isSelected = (state is Bookingswitchstate) ? state.isSelected : false;
                      return SwitchListTile(
                        activeTrackColor: Colors.indigoAccent,
                        title: Text(isSelected ? 'اعاده' : 'جديد',),
                        value: isSelected,
                        onChanged: (value) {
                          BookingCubit.get(context).toogel();
                        },
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if(edit = false)
                          BookingCubit.get(context).newBookin(
                          time: Date,
                          DayType: DayType,
                          contact: 'خاص',
                          name: '${getpatientDataCubit.get(context).patientname}',
                          again: isSelected,
                          patcode: PatientCodeControler.text,
                          Contact: SelectedContact,
                        );
                        if(edit = true)
                          print('$edit');
                          print(selectedNo);
                          BookingCubit.get(context).getBookindata();
                      },
                      child: Text('send')
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
