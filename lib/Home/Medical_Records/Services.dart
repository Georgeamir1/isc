import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import 'package:screenshot/screenshot.dart';

class Services extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecordssCubit()),
        BlocProvider(create: (context) => getDrugsDataCubit()..getServicedata()),
        BlocProvider(create: (context) => GetservicesDateCubit()),
        BlocProvider(create: (context) => ServicessCubit()),
        BlocProvider(create: (context) => CombinedDateCubit2())
      ],
      child: BlocConsumer<ServicessCubit, ServicesState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red, // Optional: Change color if needed
              ),
            );
          }

        },
        builder: (context, state) {
          // Ensure controllers list has the expected length
          final controllers = state.controllers;
          if (controllers.length != controllers.length ) {
            // Handle the mismatch, perhaps show an error message or log the issue
            return Center(child: Text('Controllers length mismatch'));
          }
          if (state is GetPrescreptionDataLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return Directionality(
            textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr,

            child: Scaffold(
              backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
              appBar: CustomAppBar(title: isArabicsaved?'الخدمات':'Services'),
              body: Screenshot(
                controller: screenshotController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 12,),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controllers.length,
                          itemBuilder: (context, index) {
                            if (index < controllers.length) {
                              final controller4 = controllers[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: servicesitems( controller1: controller4,),
                              );
                            } else {
                              return SizedBox.shrink(); // Return an empty widget if index is out of range
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.add_circled,
                                size: 30,
                                color: isDarkmodesaved ? Colors.white : Colors.black54,
                              ),
                              onPressed: () {
                                context.read<ServicessCubit>().addServices();
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(
                            child: Text(isArabicsaved?'تم':'Done'),

                            onPressed: () async {
                              print('............$docslenth');

                            final Services = context.read<ServicessCubit>()
                                .getServices();
                            final completer = Completer<void>();
                            final currentState = state;
                            final lastIndex = currentState.controllers.length -
                                1;
                            if (lastIndex < 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'No controllers available to add Services')));
                              return;
                            }

                            final medNameController = currentState.controllers[lastIndex];
                            final newServicesicationName = medNameController.text;
                            if (newServicesicationName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Service name cannot be empty')));
                              return;
                            }
                            final isDuplicate = currentState.Services
                                .any((REC) => REC['name'] == newServicesicationName);

                            if (isDuplicate) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Service is duplicated')));
                              return;
                            }
                            if (newServicesicationName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Service is duplicated')));
                              return;
                            }
                            for (var REC in Services) {
                              context.read<GetservicesDateCubit>()
                                  .NewService(
                                PatientName: "$patientname",
                                patcode: '$patientcode',
                                disname: '${REC['name']}',
                                Docno: '${docslenth}',
                              )
                                  .then((_) {
                                // Complete the completer when all prescriptions are processed
                                completer.complete();
                              })
                                  .catchError((error) {
                                // Complete the completer with an error if there's an issue
                                completer.completeError(error);
                              });
                            }
                            if (serviceonly == true) {
                              docslenth++;
                            }

                            else {}
                            Navigator.pop(context);

                            try {
                              await completer.future;
                              final state = context
                                  .read<GetservicesDateCubit>()
                                  .state;
                              // if (state is GetServiceDataSuccessState) {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => MedicalRecords()), // Replace Home with your actual homepage widget
                              //   );
                              // }
                            } catch (error) {
                              // Handle any errors here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                    'Failed to add prescription.')),
                              );
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
