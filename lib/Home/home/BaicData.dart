import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:isc/Home/home/BasicdataDoctors.dart';
import 'package:isc/Home/home/BasicdataPatients.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import '../Booking/newPatient.dart';
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

          return Scaffold(
            appBar: CustomAppBar(title: 'Medical Records'),
            backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     CustomwhiteContainer(
                  //       width: 70,
                  //       height: 50,
                  //       child: ReusableTextFormField(
                  //         keyboardType: TextInputType.number,
                  //         controller: patientCodeController,
                  //         hintText: 'Code',
                  //         onChanged: (value) {
                  //
                  //           getpatientDataCubit.get(context).updatePatientCode(value);
                  //           CombinedDateCubit2.get(context).updatePatientCode(value);
                  //           // Trigger form validation (if needed)
                  //         },
                  //       ),
                  //     ),
                  //     SizedBox(width: 12),
                  //     BlocBuilder<getpatientDataCubit, getpatientDataStatus>(
                  //       builder: (context, state) {
                  //         var cubit = getpatientDataCubit.get(context);
                  //         patientname= '${cubit.patientname2}';
                  //         print(patientname);
                  //         return Expanded(
                  //           child: CustomwhiteContainer(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: ConditionalBuilder(
                  //                 condition: state is! getpatientDataLoadingState,
                  //                 builder: (context) {
                  //                   return Text(
                  //                     patientCodeController.text.isEmpty
                  //                         ? 'Enter patient code'
                  //                         : '${cubit.patientname2}',
                  //                     style: TextStyle(
                  //                       fontSize: 20,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: isDarkmodesaved ? Colors.white : Colors.black54,
                  //                     ),
                  //                     textAlign: TextAlign.center,
                  //                   );
                  //                 },
                  //                 fallback: (context) => const LinearProgressIndicator(),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     )
                  //   ],
                  // ),
                  BlocBuilder<ChoiceChipCubit, ChoiceChipState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildChoiceChip(context, 'Patients', state),
                              buildChoiceChip(context, 'Doctors', state),
                              // buildChoiceChip(context, 'Examinations', state),
                            ],
                          ),
                          // Row(mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     buildChoiceChip(context, 'Meds', state),
                          //     SizedBox(width: 8,),
                          //     buildChoiceChip(context, 'Services', state),
                          //   ],
                          // ),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<ChoiceChipCubit, ChoiceChipState>(
                      builder: (context, chipState) {
                        if (chipState is ChoiceChipSelected &&
                            chipState.selectedChoice == 'Patients') {
                          return BasicdataPatients();

                          }
                        if (chipState is ChoiceChipSelected &&
                            chipState.selectedChoice == 'Doctors') {
                          return BasicdataDoctors();

                      }

                        else {
                          return Center(child: CustomText(Textdata: 'Please select category'));
                        }

                        }
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

                child:CustomblueContainer(
                    width: 60,
                    height: 60,
                    child:  const Icon(Icons.add,size: 30,color: Colors.white,)),
                fabSize: ExpandableFabSize.regular,
                foregroundColor: isDarkmodesaved? Colors.white:Colors.black45,
                shape: const CircleBorder(),

              ),
              closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                  fabSize: ExpandableFabSize.small,
                  foregroundColor: isDarkmodesaved? Colors.white:Colors.black45,
                  child: CustomblueContainer(
                      width: 40,
                      height: 40,
                      Radius: 10,
                      child: Icon(Icons.close))
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
                // Row(
                //   children: [
                //     CustomText(Textdata: 'User'),
                //     SizedBox(width: 4,),
                //     FloatingActionButton.small(
                //
                //       child:CustomwhiteContainer(
                //           width: 50,
                //           height: 50,
                //           child:   Icon(Icons.manage_accounts,color: isDarkmodesaved? Colors.white:Colors.black45,)),
                //       onPressed: () {
                //         navigateToPage(context, NewUsers());
                //       },
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    CustomText(Textdata: 'Patient'),
                    SizedBox(width: 4,),
                    FloatingActionButton.small(
                      // shape: const CircleBorder(),
                      heroTag: null,
                      child: CustomwhiteContainer(
                          width: 50,
                          height: 50,
                          child:  Icon(Icons.person,color: isDarkmodesaved? Colors.white:Colors.black45)),
                      onPressed: () {
                        navigateToPage(context, NewPatient());

                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
