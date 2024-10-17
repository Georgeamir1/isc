import 'dart:async';
import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/Medical%20Records.dart';
import 'package:screenshot/screenshot.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import '../Medical_Records/meds.dart';
import '../Medical_Records/records.dart';
import '../Medical_Records/Services.dart';

class addnew extends StatelessWidget {
  final TextEditingController patientCodeController = TextEditingController();
  final TextEditingController Mwds = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  TextEditingController ExaminationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AnimationCubit()),
        BlocProvider(create: (BuildContext context) => ChoiceChipCubit()),
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()),
        BlocProvider(create: (BuildContext context) => ServicessCubit()),
        BlocProvider(create: (BuildContext context) => getpatientDataCubit()),
        BlocProvider(create: (BuildContext context) => GetPrescreptionDateCubit()),
        BlocProvider(create: (BuildContext context) => GetPrescreptionDateCubit()..getdata()),
        BlocProvider(create: (BuildContext context) => GetExaminationDateCubit()..getdata()),
        BlocProvider(create: (BuildContext context) => GetservicesDateCubit()..getData()),
        BlocProvider(create: (BuildContext context) => RecordssCubit()),
        BlocProvider(create: (BuildContext context) => getDrugsDataCubit()..getDepartmentsData()),
        BlocProvider(create: (BuildContext context) => MedsCubit()),
      ],
      child:
      BlocConsumer<MedsCubit, MedsState>(
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
                    appBar: CustomAppBar(title:isArabicsaved?'الروشته': 'prescreption'),
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
                              'Examination',
                              style: TextStyle(
                                  color: isDarkmodesaved? Colors.white:Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomwhiteContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Autocomplete<Map<String, dynamic>>(
                                    optionsBuilder: (textEditingValue) {
                                      return getDrugsDataCubit
                                          .get(context)
                                          .departments
                                          .where((drug) => drug['Disease_name']
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                          .toLowerCase()));
                                    },
                                    displayStringForOption: (option) =>
                                    option['Disease_name'],
                                    onSelected:
                                        (selectedItem) {context.read<getDrugsDataCubit>().selectUser(selectedItem['Disease_name']);ExaminationController.text = selectedItem['Disease_name'];
                                      getDrugsDataCubit.get(context).getDrugsdata();
                                    },
                                    fieldViewBuilder: (context, controller,
                                        focusNode, onFieldSubmitted) {
                                      // Use the persistent controller
                                      controller.text =
                                          ExaminationController.text;
                                      return TextField(
                                        style: TextStyle(color: isDarkmodesaved? Colors.white:Colors.black45),
                                        controller: controller,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              color: isDarkmodesaved
                                                  ? Colors.white
                                                  : Colors.black54),
                                          border: InputBorder.none,
                                          hintText: ExaminationController
                                              .text.isNotEmpty
                                              ? ExaminationController.text
                                              : 'Enter Examination',
                                        ),
                                        onChanged: (value) {
                                          ExaminationController.text = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Drugs',
                              style: TextStyle(
                                  color: isDarkmodesaved? Colors.white:Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            BlocBuilder<MedsCubit, MedsState>(
                              builder: (context, state) {
                                final controllers = state.controllers;
                                final timesPerDayControllers =
                                    state.timesPerDayControllers;
                                final daysControllers = state.daysControllers;

                                if (controllers.length !=
                                    timesPerDayControllers.length ||
                                    controllers.length !=
                                        daysControllers.length) {
                                  return Center(
                                      child: Text('Controllers length mismatch'));
                                }

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
                                            if (index <
                                                timesPerDayControllers
                                                    .length &&
                                                index < daysControllers.length) {
                                              final controller2 =
                                              timesPerDayControllers[index];
                                              final controller3 =
                                              daysControllers[index];
                                              final controller4 =
                                              controllers[index];
                                              return Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: MedsItem(
                                                  daysController: controller2,
                                                  nameController: controller4,
                                                  timesPerDayController:
                                                  controller3,
                                                  index: index,
                                                ),
                                              );
                                            } else {
                                              return SizedBox.shrink();
                                            }
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
                                              'New drug',
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
                  context.read<MedsCubit>().getMedications();
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
    final completer = Completer<void>();

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
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shadowColor: Colors.grey,
            backgroundColor: Colors.grey.withOpacity(0.4),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$patientname',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text('${DateNow.substring(0, 10)}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text('code: $patientcode',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            contentPadding: EdgeInsets.only(left: 19, top: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Examination: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '     ${ExaminationController.text}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Drugs:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Prevent scrolling
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final med = medications[index];
                    return ListTile(
                      title: Text(
                        '${index + 1}- ${med['name'] ?? 'Unnamed Medicine'}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${med['timesPerDay'] ?? 'N/A'} Times per day for ${med['days'] ?? 'N/A'} Days ',
                        style: TextStyle(color: Colors.white60),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 12,
                )
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        navigateToPage(context, Services());
                      },
                      child: Text('Add service')),
                  ElevatedButton(
                    onPressed: () async {
                      if (medications.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No medications to add.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final lastIndex = state.controllers.length - 1;
                      final newMedicationName = state.controllers[lastIndex].text;
                      if (newMedicationName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Medication name cannot be empty.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Perform NewRecord addition
                      GetExaminationDateCubit.get(context).NewRecord(
                        PatientName: "$patientname",
                        patcode: '$patientcode',
                        disname: '${ExaminationController.text}',
                        Docno: '${docslenth}',
                      );

                      Completer<void> completer = Completer<void>();

                      try {
                        // Process medications
                        for (var med in medications) {
                          await context.read<GetPrescreptionDateCubit>().NewPrescreption(
                            PatientName: patientname,
                            patcode: patientcode,
                            Drugname: med['name'],
                            Docno: '$docslenth',
                            use_nam_ar: med['timesPerDay'],
                            qty: med['days'],
                          );
                        }

                        // All medications processed successfully, complete the completer
                        if (!completer.isCompleted) {
                          completer.complete();
                        }

                        // Navigate to MedicalRecords page after processing all
                        navigateToPage(context, MedicalRecords());

                      } catch (error) {
                        // If there's an error, complete with an error
                        if (!completer.isCompleted) {
                          completer.completeError(error);
                        }
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add medication.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      // Wait for the completer to complete (whether success or error)
                      await completer.future;
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Future<bool> _onWillPop(BuildContext context) async {
    // Navigate to BookingList when back button is pressed
    navigateToPage(context, MedicalRecords());
    return false; // Prevent the default back navigation
  }
}

