import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/Medical%20Records.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditServicesMedicalRecords extends StatelessWidget {
  final String docno;

  EditServicesMedicalRecords({required this.docno});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UpdateMedicalRecord()..GetRecordDrugs(docno)),
        BlocProvider(create: (context) => getDrugsDataCubit()..getDepartmentsData()),
        BlocProvider(create: (BuildContext context) => GetPrescreptionDateCubit()),
      ],
      child: _EditServicesMedicalRecordsBody(),
    );
  }
}

class _EditServicesMedicalRecordsBody extends StatefulWidget {
  @override
  _EditServicesMedicalRecordsBodyState createState() => _EditServicesMedicalRecordsBodyState();
}

class _EditServicesMedicalRecordsBodyState extends State<_EditServicesMedicalRecordsBody> {
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
                                    final use_nam_ar = drug['use_nam_ar'];
                                    final qty = drug['qty'];
                                    final drugName = drug['drug_name'];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          if (hasChanged[index])IconButton(
                                            onPressed: () {
                                              UpdateMedicalRecord.get(context).editRecordDrugs(
                                                ser: ser,
                                                doc_no: doc_no,
                                                doc_date: doc_date,
                                                code: code,
                                                pat_name: patName,
                                                drug_name: selectedDrugs[index],
                                                use_nam_ar: use_nam_ar,
                                                qty: qty,
                                              );
                                              setState(() {
                                                hasChanged[index] = false;
                                              });
                                              context.read<UpdateMedicalRecord>().GetRecordDrugs(Docno);
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
                                                items: context.read<getDrugsDataCubit>().Drugs
                                                    .map((drug) => drug['E_DESC']?.toString() ?? 'No Description')
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
                                          CustomwhiteContainer(
                                            width: 40,
                                            height: 40,
                                            child: IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red,size: 20,),
                                              onPressed: () {
                                                // Call the delete method from UpdateMedicalRecord cubit
                                                UpdateMedicalRecord.get(context).DeletRecordDrugs(ser: ser);
                                                setState(() {
                                                  // Remove the item from the local state
                                                  UpdateMedicalRecord.get(context).Drugs.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                                Divider(),
                                SizedBox(height: 10),
                                Text('Add New drug'),
                                SizedBox(height: 12,),
                                CustomwhiteContainer(
                                  child: Row(
                                    children: [
                                      Expanded(
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

                                          items: context.read<getDrugsDataCubit>().Drugs
                                              .map((drug) => drug['E_DESC']?.toString() ?? 'No Description')
                                              .toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                newPrescriptions.add({
                                                  'drug': newValue,
                                                  'timesPerDay': '',
                                                  'days': '',
                                                });
                                              });
                                            }
                                          },
                                          selectedItem: 'select new drug',
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: newPrescriptions.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
                                      child: CustomwhiteContainer(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: DropdownSearch<String>(
                                                dropdownDecoratorProps: DropDownDecoratorProps(
                                                  dropdownSearchDecoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                    hintText: "Select Drug",
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                                items: context.read<getDrugsDataCubit>().Drugs
                                                    .map((drug) => drug['E_DESC']?.toString() ?? 'No Description')
                                                    .toList(),
                                                selectedItem: newPrescriptions[index]['drug'],
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    setState(() {
                                                      newPrescriptions[index]['drug'] = newValue;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      labelText: 'Times per Day',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newPrescriptions[index]['timesPerDay'] = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      labelText: 'Days',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newPrescriptions[index]['days'] = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      newPrescriptions.removeAt(index);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 8,),
                                GestureDetector(
                                    onTap: () async {
                                      for (var prescription in newPrescriptions) {
                                        var drugName = prescription['drug']?.trim();
                                        var timesPerDay = prescription['timesPerDay'];
                                        var days = prescription['days'];

                                        bool existsInDrugsList = UpdateMedicalRecord.get(context).Drugs.any((drug) =>
                                        drug['drug_name']?.trim() == drugName);

                                        if (existsInDrugsList) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('$drugName is already included in the drug list.'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          continue;
                                        }

                                        if (drugName != null && timesPerDay != null && timesPerDay.isNotEmpty && days != null && days.isNotEmpty) {
                                          await context.read<GetPrescreptionDateCubit>().NewPrescreption(
                                            PatientName: patName,
                                            patcode: Code.toString(),
                                            Drugname: drugName,
                                            Docno: Docno.toString(),
                                            use_nam_ar: timesPerDay,
                                            qty: days.toString(),
                                          );

                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Please fill all fields for the new drug.'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      }
                                      setState(() {
                                        newPrescriptions.clear();
                                      });
                                      context.read<UpdateMedicalRecord>().GetRecordDrugs(Docno);

                                    },

                                    child: CustomblueContainer(child:
                                    Center(
                                      child: Text('save drugs',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                      width: double.infinity,))
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
