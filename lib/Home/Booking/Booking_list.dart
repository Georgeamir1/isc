import 'dart:io';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/Booking/Booking_New.dart';
import 'package:isc/Home/Booking/newPatient.dart';
import 'package:isc/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';

class BookingList extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => BookingCubit()),
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()..getdata()),
        BlocProvider(create: (BuildContext context) => SelectDateCubit()), // Initialize with today's date in the cubit
        BlocProvider(create: (BuildContext context) => AnimationCubit()), // Initialize with today's date in the cubit
      ],
      child: BlocConsumer<getDoctorDataCubit, getDoctorDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          isExpanded = false;
          var list = getDoctorDataCubit.get(context).Doctors;
          final selectDateCubit = context.watch<SelectDateCubit>();
          final selectedDateState = selectDateCubit.state;
          DateTime selectedDate = DateTime.now(); // Default to today's date
          if (selectedDateState is SelectDateChangedState) {
            selectedDate = selectedDateState.selectedDate;
          }

          // Filter the list based on the selected date (compare only the date part)
          final filteredList = list.where((item) {
            final itemDate = DateTime.parse(item['SDate']);
            return itemDate.year == selectedDate.year &&
                itemDate.month == selectedDate.month &&
                itemDate.day == selectedDate.day;
          }).toList();

          return Scaffold(
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
                      'Reservations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: PatientCodeSearchDelegate(getDoctorDataCubit.get(context).Doctors),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                  child: Row(
                    children: [
                      Expanded(
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
                          child: CustomDateTimePicker2(
                            pickerType: DateTimePickerType.date,
                            dateNotifier: ValueNotifier<DateTime>(selectedDate),
                            controller: BoardDateTimeController(),
                            onDateChanged: (selectedDate) {
                              context.read<SelectDateCubit>().selectDate(selectedDate);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
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
                          borderRadius: BorderRadius.circular(100),
                        ),
                        width: 40,
                        height: 40,
                        child: IconButton(
                          icon: Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            context.read<SelectDateCubit>().clearDate();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ConditionalBuilder(
                  condition: state is! getDoctorDataLoadingState,
                  builder: (context) {
                    if (state is getDoctorDataErrorState) {
                      return Text(
                        'Network Error',
                        style: TextStyle(
                          color: CupertinoColors.destructiveRed,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    return Expanded(
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () {
                          getDoctorDataCubit.get(context).getdata();
                          _refreshController.refreshCompleted();
                        },
                        physics: BouncingScrollPhysics(),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            // Reverse the list and access the items in the reversed order
                            final reversedList = filteredList.reversed.toList();
                            return ReservationItem(
                              data: reversedList[index],
                              onNoSelected: (no) {
                                selectedNo = no;
                                edit = true;
                                print('Selected NO: $selectedNo');
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                  fallback: (context) => Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton:
            BlocBuilder<AnimationCubit, AnimationState>(
              builder: (context, state) {
                // Assume state management handles the expanded state

                return GestureDetector(
                  onTap: () {
                    context.read<AnimationCubit>().selectAddAnimation();
                  },
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlue, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    width: isExpanded ? 300 : 60,
                    height: isExpanded ? 200 : 60,
                    curve: Curves.fastEaseInToSlowEaseOut,
                    duration: Duration(milliseconds: 300),
                    child: isExpanded ?
                    SingleChildScrollView(padding: EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.expand_more,color: Colors.white,size: 30,),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              navigateToPage(context, NewPatient());
                            },
                            child: AnimatedContainer(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                'New Patient',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              width: 280,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: Offset(2, 6),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              duration: Duration(),
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {navigateToPage(context, BookingNew());},
                            child: AnimatedContainer(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                'New Reservation',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              width: 280,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: Offset(2, 6),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              duration: Duration(milliseconds: 600),
                            ),
                          ),
                        ],
                      ),
                    )
                        :
                    Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          );
          // WillPopScope(
          //   onWillPop: () async {
          //     bool shouldExit = await _showExitConfirmationDialog(context);
          //     return shouldExit;
          //   },
          //   child: ,
          // );
        },
      ),
    );
  }
}


// Future<bool> _showExitConfirmationDialog(BuildContext context) async {
//   return await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Exit App'),
//       content: Text('Are you sure you want to exit the app?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(false),
//           child: Text('No'),
//         ),
//         TextButton(
//           onPressed: (){ exit(0);},
//           child: Text('Yes'),
//         ),
//       ],
//     ),
//   ) ?? false;
// }
