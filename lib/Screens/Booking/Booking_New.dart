import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/componants.dart';

//..............................................................................

class NewBooking extends StatelessWidget {
//..............................................................................
  final DateTimePickerType pickerType =
      DateTimePickerType.datetime; // Adjust as needed
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());
  final BoardDateTimeController controller = BoardDateTimeController();
  final List<String> Contracs = [
    'Contracs 1',
    'Contracs 2',
    'Contracs 3',
    // Add more user names here
  ];
  bool _isOption1Selected = true;
//..............................................................................
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getDoctorDataCubit()..getdata(),
      child: BlocConsumer<getDoctorDataCubit, getDoctorDataStatus>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(72.0),
                // Adjust the height for a smaller AppBar
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlue,
                        Colors.indigo
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.2), // Light shadow color
                        offset: Offset(0, 4), // Shadow position
                        blurRadius: 8, // Shadow blur radius
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      // Transparent background for gradient effect
                      elevation: 0,
                      // Remove shadow for a flatter look
                      title: Text(
                        'New Reservation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color for contrast
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //..........................................................................
              body: Padding(
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
                                  offset: Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: ('ادخل كود المريض'),
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
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '  : كود المريض ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //....................................................................
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
                        child: Text(
                          'اشرف ياسر حسين ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //....................................................................
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
                        pickerType: pickerType,
                        dateNotifier: dateNotifier,
                        controller: controller,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //....................................................................
                    Container(
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
                      child: RDropdownSearch(
                          items: Contracs,
                          hintText: "اختر تعاقد",
                          showSearchBox: false),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //....................................................................
                    SwitchListTile(
                      title: Text('Option 1'),
                      value: _isOption1Selected,
                      onChanged: (value) {},
                      subtitle: Text(_isOption1Selected
                          ? 'Selected Option 1'
                          : 'Selected Option 2'),
                    ),
                    //....................................................................
                  ],
                ),
                //......................................................................
              ),
              //........................................................................
            );
          }),
    );
    //............................................................................
  }
//..............................................................................
}

//..............................................................................