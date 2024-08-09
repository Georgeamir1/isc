import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Screens/Booking/Booking_New.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../onboarding/test.dart';
//..............................................................................

class BookingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(BuildContext context)=> getDoctorDataCubit() ..getdata(),
        child: BlocConsumer<getDoctorDataCubit,getDoctorDataStatus>(
          listener:(context,state) {
          },
          builder: (context,state){
            var list =  getDoctorDataCubit.get(context).Doctors;
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(72.0),
                // Adjust the height for a smaller AppBar
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.indigo],
                      // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        // Light shadow color
                        offset: Offset(0, 4),
                        // Shadow position
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
                        'Reservations',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          // Text color for contrast
                          letterSpacing: 1.2,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          // Icon color for contrast
                          onPressed: () {
                            // Handle search action
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              body:
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 50),
                    child: Container(
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
                        pickerType: DateTimePickerType.date,
                        dateNotifier: ValueNotifier(DateTime.now()),
                        controller: BoardDateTimeController(),
                      ),
                    ),
                  ),

                  ConditionalBuilder(
                      condition: state is! getDoctorDataLoadingState,
                      builder: (context) {
                        if (state is getDoctorDataErrorState)
                          return Text(
                            'Network Error',
                            style: TextStyle(
                                color: CupertinoColors.destructiveRed,
                                fontSize:30,
                                fontWeight: FontWeight.bold)
                            ,);
                        return  Expanded(
                          child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) =>
                          ReservationItem(list[index])),
                        );


                      },
                      fallback: (context)=> Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      )),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                shape: CircleBorder(eccentricity: 1),
                onPressed: () {
                  navigateToPage(
                    context,
                    NewBookingstatfull(),
                  );
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black54,
                ),
                backgroundColor: Colors.grey[
                100], // Customize the background color as needed
              ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
            );





          },
        ));

  }
//..............................................................................
}

//..............................................................................
