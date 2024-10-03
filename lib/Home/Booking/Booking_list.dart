import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:isc/Home/Booking/Booking_New.dart';
import 'package:isc/Home/Booking/newPatient.dart';
import 'package:isc/Home/home/Home.dart';
import 'package:isc/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';

class BookingList extends StatelessWidget {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

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
          final _key = GlobalKey<ExpandableFabState>();
          isExpanded = false;
          var list = getDoctorDataCubit.get(context).Doctors;
          final selectDateCubit = context.watch<SelectDateCubit>();
          final selectedDateState = selectDateCubit.state;
          DateTime selectedDate = DateTime.now(); // Default to today's date
          if (selectedDateState is SelectDateChangedState) {
            selectedDate = selectedDateState.selectedDate;
          }
          final filteredList = list.where((item) {
            final itemDate = DateTime.parse(item['SDate']);
            return itemDate.year == selectedDate.year &&
                itemDate.month == selectedDate.month &&
                itemDate.day == selectedDate.day;
          }).toList();
          return Directionality(
            textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr,
            child: WillPopScope(
              onWillPop: () => _onWillPop(context),
              child: Scaffold(
                appBar: CustomAppBar(
                  title:isArabicsaved ? 'الحجوزات' : 'Reservations',
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: PatientCodeSearchDelegate(getDoctorDataCubit.get(context).Doctors),
                          );
                        },
                        icon: Icon(Icons.search, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                ),

                backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomwhiteContainer(
                              height: 35,
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
                          SizedBox(width: 8),
                          CustomwhiteContainer(
                            width: 40,
                            height: 40,
                            Radius: 100,
                            child: IconButton(
                              icon: Icon(Icons.clear, color: isDarkmodesaved ? Colors.white : Colors.black54),
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
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isArabicsaved ? 'خطأ في الشبكة' : 'Network Error',
                                  style: TextStyle(
                                    color: Color(0xFFbd0000),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                                final reversedList = filteredList.reversed.toList();
                                return ReservationItem(
                                  data: reversedList[index],
                                  onNoSelected: (no) {
                                    selectedNo = no;
                                    edit = true;
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
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: ExpandableFab(
                  key: _key,
                  duration: const Duration(milliseconds: 400),
                  distance: 50.0,
                  type: ExpandableFabType.up,
                  pos: ExpandableFabPos.right,
                  childrenOffset: const Offset(-3, 0),
                  childrenAnimation: ExpandableFabAnimation.rotate,
                  fanAngle: 100,
                  openButtonBuilder: RotateFloatingActionButtonBuilder(
                    child: CustomblueContainer(
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.add, size: 30, color: Colors.white),
                    ),
                    fabSize: ExpandableFabSize.regular,
                    foregroundColor: isDarkmodesaved ? Colors.white : Colors.black45,
                    shape: const CircleBorder(),
                  ),
                  closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                    fabSize: ExpandableFabSize.small,
                    foregroundColor: isDarkmodesaved ? Colors.white : Colors.black45,
                    child: CustomblueContainer(
                      width: 40,
                      height: 40,
                      Radius: 10,
                      child: Icon(Icons.close),
                    ),
                  ),
                  overlayStyle: ExpandableFabOverlayStyle(
                    color: Colors.black.withOpacity(0.5),
                    blur: 5,
                  ),
                  onOpen: () {
                    debugPrint('onOpen');
                  },
                  afterOpen: () {
                    debugPrint('afterOpen');
                  },
                  onClose: () {
                    debugPrint('onClose');
                  },
                  afterClose: () {
                    debugPrint('afterClose');
                  },
                  children: [
                    FloatingActionButton.small(
                      heroTag: null,
                      child: CustomwhiteContainer(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.post_add, color: isDarkmodesaved ? Colors.white : Colors.black45),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingNew()));
                      },
                    ),
                    FloatingActionButton.small(
                      heroTag: null,
                      child: CustomwhiteContainer(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.person, color: isDarkmodesaved ? Colors.white : Colors.black45),
                      ),
                      onPressed: () {
                        navigateToPage(context, NewPatient());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    navigateToPage(context, Home());
    return false; // Prevent the default back navigation
  }
}
