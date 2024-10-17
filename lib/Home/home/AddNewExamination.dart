import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/BaicData.dart';
import 'package:screenshot/screenshot.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';


class AddNewExamination extends StatelessWidget {
  final TextEditingController Mwds = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  TextEditingController ExaminationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getDrugsDataCubit()..getExaminationdata()),
        BlocProvider(create: (BuildContext context) => MedsCubit()),
      ],
      child: BlocConsumer<MedsCubit, MedsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {

          return WillPopScope(
            onWillPop: () => _onWillPop(context),

            child: Scaffold(
              body: BlocConsumer<getDrugsDataCubit, getDrugsDataStatus>(
                listener: (context, state) {},
                builder: (context, state) {

                  return Scaffold(
                    appBar: CustomAppBar(title:isArabicsaved?'اضافه تشخيص جديد': 'Add new examination'),
                    backgroundColor:
                    isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                    body: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Examinations',
                              style: TextStyle(
                                  color: isDarkmodesaved? Colors.white:Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            BlocBuilder<MedsCubit, MedsState>(
                              builder: (context, state) {
                                final controllers = state.controllers;
                                return Screenshot(
                                  controller: screenshotController,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controllers.length,
                                          itemBuilder: (context, index) {
                                            final controller4 =
                                            controllers[index];
                                            return Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: NewExaminationItem(
                                                nameController: controller4,
                                                index: index,
                                              ),
                                            );
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                CupertinoIcons.add_circled,
                                                size: 30,
                                                color: isDarkmodesaved
                                                    ? Colors.white
                                                    : Colors.black54,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<MedsCubit>()
                                                    .addMed();
                                              },
                                            ),
                                            Text(
                                              'New Examination',
                                              style: TextStyle(
                                                color: isDarkmodesaved? Colors.white:Colors.black45,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: GestureDetector(
                onTap: () {
                  _handleAddButton(context, state);
                },
                child: CustomblueContainer(
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAddButton(BuildContext context, MedsState state) async {
    final medications = context.read<MedsCubit>().getMedications();
    final currentState = state;
    final lastIndex = currentState.controllers.length - 1;
    if (lastIndex < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No controllers available to add medication'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final medNameController = currentState.controllers[lastIndex];
    final newMedicationName = medNameController.text;
    if (newMedicationName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medication name cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final isDuplicate =
    currentState.medications.any((med) => med['name'] == newMedicationName);

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medication is duplicated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Fetch the initial list of drugs
    List<Map<String, dynamic>> drugs = await context.read<getDrugsDataCubit>().Examinations;
// Initialize the counter for 'noo' based on the length of the drugs list
    int? noo = drugs.length;
     bool exists =false;
// Iterate through the medications
    for (var med in medications) {
      // Check if the medication name already exists in the drugs list
       exists = drugs.any((drug) => drug['Disease_name'] == med['name']);
      if (!exists) {
        await context.read<getDrugsDataCubit>().NewExamination(
          noo: (noo! + 1)!,
          NAME: med['name'],
        );

        // Update the 'drugs' list after adding a new drug
        drugs = await context.read<getDrugsDataCubit>().Examinations;

        // Increment 'noo' since we added a new drug
        noo++;
      }
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Examination  (${med['name']}) is already exists'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
    context.read<getDrugsDataCubit>().getExaminationdata();
    navigateToPage(context, Basicdata());





  }
  Future<bool> _onWillPop(BuildContext context) async {
    // Navigate to BookingList when back button is pressed
    navigateToPage(context, Basicdata());
    return false; // Prevent the default back navigation
  }
}
