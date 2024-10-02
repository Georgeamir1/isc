// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:isc/Home/Medical_Records/records.dart';
// import 'package:isc/Home/home/Home.dart';
// import 'package:isc/Home/home/Medical%20Records.dart';
// import 'package:isc/shared/componants.dart';
// import '../../State_manage/Cubits/cubit.dart';
// import '../../State_manage/States/States.dart';
// import '../../shared/Data.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
//
// class Meds extends StatelessWidget {
//   final ScreenshotController screenshotController = ScreenshotController();
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => MedsCubit()),
//         BlocProvider(create: (context) => getDrugsDataCubit()..getDrugsdata()),
//         BlocProvider(create: (context) => GetPrescreptionDateCubit()),
//         BlocProvider(create: (context) => CombinedDateCubit2())
//       ],
//       child: BlocConsumer<MedsCubit, MedsState>(
//         listener: (context, state) {
//           if (state.error != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.error!),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final controllers = state.controllers;
//           final timesPerDayControllers = state.timesPerDayControllers;
//           final daysControllers = state.daysControllers;
//
//           if (controllers.length != timesPerDayControllers.length ||
//               controllers.length != daysControllers.length) {
//             return Center(child: Text('Controllers length mismatch'));
//           }
//
//           if (state is GetPrescreptionDataLoadingState) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           return Scaffold(
//             backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
//             body: Screenshot(
//               controller: screenshotController,
//               child: SingleChildScrollView(
//                 child:
//                 Column(
//                   children: [
//                     ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: controllers.length,
//                       itemBuilder: (context, index) {
//                         if (index < timesPerDayControllers.length &&
//                             index < daysControllers.length) {
//                           final controller4 = controllers[index];
//                           final controller2 = timesPerDayControllers[index];
//                           final controller3 = daysControllers[index];
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: medsitems(
//                               controller2: controller2,
//                               controller3: controller3,
//                               controller4: controller4,
//                             ),
//                           );
//                         } else {
//                           print('Index out of bounds in ListView.builder: index=$index');
//                           return SizedBox.shrink();
//                         }
//                       },
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         IconButton(
//                           icon: Icon(
//                             CupertinoIcons.add_circled,
//                             size: 30,
//                             color: isDarkmodesaved ? Colors.white : Colors.black54,
//                           ),
//                           onPressed: () {
//                             context.read<MedsCubit>().addMed();
//
//                           },
//                         ),
//                       ],
//                     ),
//                     ElevatedButton(
//                       onPressed: () => _handleAddButton(context, state),
//                       child: Text('show'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _handleAddButton(BuildContext context, MedsState state) async {
//     final medications = context.read<MedsCubit>().getMedications();
//     final completer = Completer<void>();
//
//     final currentState = state;
//     final lastIndex = currentState.controllers.length - 1;
//     if (lastIndex < 0) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('No controllers available to add medication'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     final medNameController = currentState.controllers[lastIndex];
//     final newMedicationName = medNameController.text;
//
//     if (newMedicationName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Medication name cannot be empty'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     final isDuplicate = currentState.medications.any((med) => med['name'] == newMedicationName);
//
//     if (isDuplicate) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Medication is duplicated'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) { // Use a different variable name to avoid confusion
//         return AlertDialog(
//           backgroundColor: invertedbackgroundcolor,
//           title: Text('Medicines', style: TextStyle(color: invertedtextcolor)),
//           contentPadding: EdgeInsets.only(left: 12,top: 8),
//           content: Container(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: medications.length,
//               itemBuilder: (context, index) {
//                 final med = medications[index];
//                 return ListTile(
//                   title: Text(
//                     '${index + 1}- ${med['name'] ?? 'Unnamed Medicine'}',
//                     style: TextStyle(color: invertedtextcolor),
//                   ),
//                   subtitle: Text(
//                     '${med['timesPerDay'] ?? 'N/A'} Times per day for ${med['days'] ?? 'N/A'} Days ',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 if (medications.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('No medications to add.'), backgroundColor: Colors.red),
//                   );
//                   return;
//                 }
//
//                 final lastIndex = state.controllers.length - 1;
//                 final newMedicationName = state.controllers[lastIndex].text;
//
//                 if (newMedicationName.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Medication name cannot be empty.'), backgroundColor: Colors.red),
//                   );
//                   return;
//                 }
//
//
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Added Successfully.'), backgroundColor: Colors.green),
//                 );
//
//                 for (var med in medications) {
//                   try {
//                     await context.read<MedsCubit>().NewPrescription(
//                       PatientName: patientname,
//                       patcode: patientcode,
//                       Drugname: med['name'],
//                       Docno: '$docslenth',
//                     );
//                     completer.complete();
//                   } catch (error) {
//                     print(error);
//                     completer.completeError(error);
//                     break;
//                   }
//                 }
//
//                 try {
//                   await completer.future;
//                 } catch (error) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Failed to add medication.'), backgroundColor: Colors.red),
//                   );
//                 }
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _captureConvertAndPrint(BuildContext context) async {
//     Uint8List? capturedImage = await screenshotController.capture();
//
//     if (capturedImage != null) {
//       final pdfDocument = pw.Document();
//       final pdfImage = pw.MemoryImage(capturedImage);
//
//       pdfDocument.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Image(pdfImage),
//             );
//           },
//         ),
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Screenshot captured, converted to PDF, and printing...')),
//       );
//
//       await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdfDocument.save(),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to capture screenshot.')),
//       );
//     }
//   }
// }
