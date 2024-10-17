import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/Medical%20Records.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Editexaminationmedicalrecords extends StatelessWidget {
  final String docno;

  Editexaminationmedicalrecords({required this.docno});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UpdateMedicalRecord()..GetRecordExamination(docno)),
        BlocProvider(create: (context) => getDrugsDataCubit()..getExaminationdata()),
        BlocProvider(create: (BuildContext context) => GetPrescreptionDateCubit()),
      ],
      child: _EditexaminationmedicalrecordsBody(),
    );
  }
}

class _EditexaminationmedicalrecordsBody extends StatefulWidget {
  @override
  _EditexaminationmedicalrecordsState createState() => _EditexaminationmedicalrecordsState();
}

class _EditexaminationmedicalrecordsState extends State<_EditexaminationmedicalrecordsBody> {
  List<String?> selectedDrugs = [];
  List<bool> hasChanged = [];
  List<Map<String, String>> newPrescriptions = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateMedicalRecord, UploadMedicalRecordStatus>(
      listener: (context, state) {},
      builder: (context, state) {
        String patName = 'Loading...';
        String docDate = '';
        String Code = '';
        String Docno = '';

        if (state is UploadDrugsRecordSuccessState && UpdateMedicalRecord.get(context).Drugs.isNotEmpty) {
          if (selectedDrugs.length != UpdateMedicalRecord.get(context).Drugs.length) {
            selectedDrugs = List<String?>.filled(UpdateMedicalRecord.get(context).Drugs.length, null);
            hasChanged = List<bool>.filled(UpdateMedicalRecord.get(context).Drugs.length, false);
          }

          patName = UpdateMedicalRecord.get(context).Drugs[0]['pat_name']?.toString() ?? 'Unknown';
          docDate = UpdateMedicalRecord.get(context).Drugs[0]['doc_date']?.toString() ?? '';
          Code = UpdateMedicalRecord.get(context).Drugs[0]['code']?.toString() ?? '';
          Docno = UpdateMedicalRecord.get(context).Drugs[0]['doc_no']?.toString() ?? '';
        } else if (state is UploadDrugsRecordErrorState) {
          patName = 'Error loading data';
        }

        return WillPopScope(
          onWillPop: () => _onWillPop(context),

          child: Scaffold(
            backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
            appBar: CustomAppBar(
              title: patName,
              subtitelbool: true,
              subtitel: '${docDate.isNotEmpty ? docDate.split('T')[0] : ''}',
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 18.0,),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is UploadDrugsRecordLoadingState)
                        Center(child: CircularProgressIndicator()),
                      if (state is UploadDrugsRecordErrorState)
                        Center(child: Text('Failed to load data: ${state.error}')),
                      if (state is UploadDrugsRecordSuccessState && UpdateMedicalRecord.get(context).Drugs.isNotEmpty)
                        BlocBuilder<getDrugsDataCubit, getDrugsDataStatus>(
                          builder: (context, drugState) {
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: UpdateMedicalRecord.get(context).Drugs.length,
                                  itemBuilder: (context, index) {
                                    final drug = UpdateMedicalRecord.get(context).Drugs[index];
                                    final ser = drug['ser'];
                                    final doc_no = drug['doc_no'];
                                    final doc_date = drug['doc_date'];
                                    final code = drug['code'];
                                    final drugName = drug['dis_name'];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          if (hasChanged[index])IconButton(
                                            onPressed: () {
                                              UpdateMedicalRecord.get(context).editRecordExamination(
                                                ser: ser,
                                                doc_no: doc_no,
                                                doc_date: doc_date,
                                                code: code,
                                                pat_name: patName,
                                                drug_name: selectedDrugs[index],
                                              );
                                              setState(() {
                                                hasChanged[index] = false;
                                              });
                                              context.read<UpdateMedicalRecord>().GetRecordExamination(Docno);
                                            },
                                            icon: Icon(Icons.check_box, color: Colors.green),
                                          ),
                                          Expanded(
                                            child: CustomwhiteContainer(
                                              child: DropdownSearch<String>(
                                                dropdownDecoratorProps: DropDownDecoratorProps(
                                                  dropdownSearchDecoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                    hintText: "Select Drug",
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                                items: context.read<getDrugsDataCubit>().Examinations
                                                    .map((drug) => drug['Disease_name']?.toString() ?? 'No Description')
                                                    .toList(),
                                                selectedItem: selectedDrugs[index] ?? drugName,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    if (newValue != null) {
                                                      final existingDrugs = UpdateMedicalRecord.get(context).Drugs
                                                          .map((d) => d['drug_name'])
                                                          .toList();

                                                      if (existingDrugs.contains(newValue)) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Cannot add duplicated drug: $newValue'),
                                                            duration: Duration(seconds: 2),
                                                          ),
                                                        );
                                                      } else {
                                                        selectedDrugs[index] = newValue;
                                                        hasChanged[index] = true;
                                                      }
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4,),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10),


                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
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
