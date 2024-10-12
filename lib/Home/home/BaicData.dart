import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:isc/Home/home/BasicdataDoctors.dart';
import 'package:isc/Home/home/BasicdataPatients.dart';
import 'package:isc/Home/home/Home.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import '../Booking/newPatient.dart';
import 'AddNewDrug.dart';
import 'AddNewExamination.dart';
import 'BasicDataDrugs.dart';
import 'BasicDataExaminations.dart';
import 'NewUsers.dart';

class Basicdata extends StatelessWidget {
  final _key = GlobalKey<ExpandableFabState>();
  final TextEditingController patientCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => ChoiceChipCubit()),
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()),
        BlocProvider(create: (BuildContext context) => getpatientDataCubit()),
        BlocProvider(create: (BuildContext context) => CombinedDateCubit2()),
      ],
      child: BlocConsumer<CombinedDateCubit2, CombinedDateState2>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = getpatientDataCubit.get(context);

          return Directionality(
            textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr,
            child: WillPopScope(
              onWillPop: () => _onWillPop(context),

              child: Scaffold(
                appBar: CustomAppBar(
                  title: isArabicsaved ? 'البيانات الاساسية' : 'Basic data',
                ),
                backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                body: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: isArabicsaved ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Arabic-specific customization for patient code input
                      // Add Row for Code Input (optional, currently commented out)

                      BlocBuilder<ChoiceChipCubit, ChoiceChipState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: isArabicsaved ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildChoiceChip(context, isArabicsaved ? 'المرضى' : 'Patients', state),
                                  buildChoiceChip(context, isArabicsaved ? 'الأطباء' : 'Doctors', state),
                                  buildChoiceChip(context, isArabicsaved ? 'الادويه' : 'Drugs', state),
                                  // You can uncomment this if necessary
                                  // buildChoiceChip(context, 'Examinations', state),
                                ],
                              ),
                              Row(
                                children: [
                                  buildChoiceChip(context, isArabicsaved ? 'التشخيصات' : 'Examination', state),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                      Expanded(
                        child: BlocBuilder<ChoiceChipCubit, ChoiceChipState>(
                          builder: (context, chipState) {
                            if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == (isArabicsaved ? 'المرضى' : 'Patients')) {
                              return BasicdataPatients();
                            } if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == (isArabicsaved ? 'الادويه' : 'Drugs')) {
                              return BasicDataDrugs();
                            }
                            if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == (isArabicsaved ? 'الأطباء' : 'Doctors')) {
                              return BasicdataDoctors();
                            } if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == (isArabicsaved ? 'التشخيصات' : 'Examination')) {
                              return BasicDataExaminations();
                            } else {
                              return Center(
                                child: CustomText(
                                  Textdata: isArabicsaved ? 'الرجاء اختيار الفئة' : 'Please select category',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
                      child: Icon(Icons.close,color: Colors.white,),
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
                    Row(
                      children: [
                        CustomText(Textdata: isArabicsaved ? 'مريض' : 'Patient',color: Colors.white),
                        SizedBox(width: 4),
                        FloatingActionButton.small(
                          heroTag: null,
                          child: CustomwhiteContainer(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.person,
                              color: isDarkmodesaved ? Colors.white : Colors.black45,
                            ),
                          ),
                          onPressed: () {
                            navigateToPage(context, NewPatient());
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(Textdata: isArabicsaved ? 'دواء' : 'Drug',color: Colors.white,),
                        SizedBox(width: 4),
                        FloatingActionButton.small(
                          heroTag: null,
                          child: CustomwhiteContainer(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.medical_services,
                              color: isDarkmodesaved ? Colors.white : Colors.black45,
                            ),
                          ),
                          onPressed: () {
                            navigateToPage(context, addnewDrug());
                          },
                        ),


                      ],
                    ),
                    Row(
                      children: [
                        CustomText(Textdata: isArabicsaved ? 'تشخيص' : 'Examination',color: Colors.white),
                        SizedBox(width: 4),
                        FloatingActionButton.small(
                          heroTag: null,
                          child: CustomwhiteContainer(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.assignment,
                              color: isDarkmodesaved ? Colors.white : Colors.black45,
                            ),
                          ),
                          onPressed: () {
                            navigateToPage(context, AddNewExamination());
                          },
                        ),
                      ],
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
    // Navigate to BookingList when back button is pressed
    navigateToPage(context, Home());
    return false; // Prevent the default back navigation
  }
}
