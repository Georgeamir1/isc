import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Screens/Booking/Booking_New.dart';
import 'package:isc/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';

class BookingList extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:
    [
      BlocProvider(create: (BuildContext context) => BookingCubit()..getBookindata()),
      BlocProvider(create: (BuildContext context) => getDoctorDataCubit()..getdata()),
    ],
      child: BlocConsumer<BookingCubit, Bookingtatus>(
        listener: (context, state) {},
        builder: (context, state) {
          var list = getDoctorDataCubit.get(context).Doctors;
          edit = false;
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
                          // Handle search action
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
                          itemCount: list.length,
                          itemBuilder: (context, index) => ReservationItem(
                            data: list[index],
                            onNoSelected: (no) {
                              selectedNo = no;
                              edit = true;
                              print('Selected NO: $selectedNo');
                            },
                          ),
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
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(eccentricity: 1),
              onPressed: () {
                edit = false;
                navigateToPage(
                  context,
                  BookingNew(),
                );
              },
              child: Icon(
                Icons.add,
                size: 30,
                color: Colors.black54,
              ),
              backgroundColor: Colors.grey[100],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
          );
        },
      ),
    );
  }
}
