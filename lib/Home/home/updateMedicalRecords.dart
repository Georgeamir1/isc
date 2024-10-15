import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/BaicData.dart';
import 'package:isc/Home/home/Medical%20Records.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class UpdateMedicalRecords extends StatefulWidget {
  final String docno;

  UpdateMedicalRecords({required this.docno});

  @override
  _UpdateMedicalRecordsState createState() => _UpdateMedicalRecordsState();
}

class _UpdateMedicalRecordsState extends State<UpdateMedicalRecords> {
  List<String?> selectedDrugs = []; // List to hold selected drugs for each item
  List<bool> hasChanged = []; // List to track changes for each drug selection

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
            UpdateMedicalRecord()..GetRecordDrugs(widget.docno)),
        BlocProvider(create: (BuildContext context) => getDrugsDataCubit()..getDrugsdata()),
      ],
      child: BlocConsumer<UpdateMedicalRecord, UploadMedicalRecordStatus>(
        listener: (context, state) {
          // Additional listeners if needed
        },
        builder: (context, state) {
          String patName = 'Loading...';
          String docDate = '';

          if (state is UploadDrugsRecordSuccessState &&
              UpdateMedicalRecord.get(context).Drugs.isNotEmpty) {
            patName = UpdateMedicalRecord.get(context).Drugs[0]['pat_name'] ?? 'Unknown';
            docDate = UpdateMedicalRecord.get(context).Drugs[0]['doc_date'] ?? '';
            // Initialize selected drugs list based on the number of drugs
            if (selectedDrugs.isEmpty) {
              selectedDrugs = List<String?>.filled(UpdateMedicalRecord.get(context).Drugs.length, null);
              hasChanged = List<bool>.filled(UpdateMedicalRecord.get(context).Drugs.length, false); // Initialize change tracking
            }
          } else if (state is UploadDrugsRecordErrorState) {
            patName = 'Error loading data';
          }

          return WillPopScope(
            onWillPop: () => _onWillPop(context),

            child: Scaffold(
              appBar: CustomAppBar(title: '$patName \n${docDate.isNotEmpty ? docDate.split('T')[0] : ''}'),
              backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        shape: InputBorder.none,
                        title: Text('Drugs'),
                        children: [
                          if (state is UploadDrugsRecordLoadingState)
                            Center(child: CircularProgressIndicator()),
                          if (state is UploadDrugsRecordErrorState)
                            Center(child: Text('Failed to load data: ${state.error}')),
                          if (state is UploadDrugsRecordSuccessState && UpdateMedicalRecord.get(context).Drugs.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocBuilder<getDrugsDataCubit, getDrugsDataStatus>(
                                builder: (context, state) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: UpdateMedicalRecord.get(context).Drugs.length,
                                    itemBuilder: (context, index) {
                                      final drug = UpdateMedicalRecord.get(context).Drugs[index];
                                      final drugName = drug['drug_name'];
                                      final ser = drug['ser'];
                                      final doc_no = drug['doc_no'];
                                      final doc_date = drug['doc_date'];
                                      final code = drug['code'];
                                      final use_nam_ar = drug['use_nam_ar'];
                                      final qty = drug['qty'];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomwhiteContainer(
                                                child: DropdownSearch<String>(
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                    baseStyle: TextStyle(
                                                      color: isDarkmodesaved
                                                          ? Colors.white
                                                          : Colors.black45,
                                                    ),
                                                    dropdownSearchDecoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(
                                                          horizontal: 16, vertical: 12),
                                                      hintText: isArabicsaved ? 'اختر مستخدم' : "Select User",
                                                      hintStyle: TextStyle(
                                                        color: isDarkmodesaved
                                                            ? Colors.white
                                                            : Colors.grey[600],
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      suffixIconColor:
                                                      isDarkmode ? Colors.white : Colors.black45,
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: BorderSide(
                                                            color: Colors.blueAccent, width: 2),
                                                      ),
                                                    ),
                                                  ),
                                                  items: getDrugsDataCubit.get(context).Drugs
                                                      .map((department) => department['E_DESC']?.toString() ?? 'No Description')
                                                      .toList(),
                                                  selectedItem: selectedDrugs[index] ?? drugName, // Use selected drug for the current index
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      selectedDrugs[index] = newValue; // Update the selected drug in the list
                                                      hasChanged[index] = true; // Mark as changed
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            if (hasChanged[index]) // Show icon button only if value has changed
                                              IconButton(
                                                onPressed: () {
                                                  UpdateMedicalRecord.get(context).editRecordDrugs(
                                                    ser: ser,
                                                    doc_no: doc_no,
                                                    doc_date: doc_date,
                                                    code: code,
                                                    pat_name: patName,
                                                    drug_name: selectedDrugs[index],
                                                    use_nam_ar: use_nam_ar,
                                                    qty: qty, // Send the selected drug
                                                  );
                                                  setState(() {
                                                    hasChanged[index] = false; // Reset change status
                                                  });
                                                },
                                                icon: Icon(Icons.check_box, color: Colors.green),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
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

  Future<bool> _onWillPop(BuildContext context) async {
    navigateToPage(context, MedicalRecords());
    return false; // Prevent the default back navigation
  }
}
