import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/Home.dart';
import 'package:isc/Home/home/Medical%20Records.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import 'package:screenshot/screenshot.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';

class Services extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecordssCubit()),
        BlocProvider(create: (context) => getDrugsDataCubit()..getDrugsdata()),
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
          return Scaffold(
            backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
            appBar: CustomAppBar(title: 'Services'),
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
                            print('Index out of bounds in ListView.builder: index=$index');
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
                        onPressed: () async {
                          print('Patient Name: $patientname');
                          print('Patient Code: $patientcode');
                          print('Docslenth: $docslenth');
                          final Services = context.read<ServicessCubit>().getServices();
                          print('Services: $Services');
                          final completer = Completer<void>();
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
                          if (serviceonly == true)
                            {
                              print (serviceonly);
                              docslenth++;
                            }

                          else  {}
                          Navigator.pop(context);

                          try {
                            await completer.future;
                            final state = context.read<GetservicesDateCubit>().state;
                            // if (state is GetServiceDataSuccessState) {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => MedicalRecords()), // Replace Home with your actual homepage widget
                            //   );
                            // }
                          } catch (error) {
                            // Handle any errors here
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to add prescription.')),
                            );
                          }
                        },
                        child: Text('Done'),
                      ),
                    ],
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
