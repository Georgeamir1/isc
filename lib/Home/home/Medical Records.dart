import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/Medical_Records/meds.dart';
import 'package:isc/Home/home/updateMedicalRecords.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';
import '../Medical_Records/Services.dart';
import '../Medical_Records/add new.dart';
import 'Home.dart';

class MedicalRecords extends StatelessWidget {
  final TextEditingController patientCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AnimationCubit()),
        BlocProvider(create: (BuildContext context) => ChoiceChipCubit()),
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()),
        BlocProvider(
            create: (BuildContext context) =>
                CombinedDateCubit2()..getAllDateCodePairs()),
        BlocProvider(create: (BuildContext context) => getpatientDataCubit()),
        BlocProvider(
            create: (BuildContext context) =>
                GetPrescreptionDateCubit()..getdata()),
        BlocProvider(
            create: (BuildContext context) =>
                GetExaminationDateCubit()..getdata()),
        BlocProvider(
            create: (BuildContext context) =>
                GetservicesDateCubit()..getData()),
        // Add other cubits here
      ],
      child: BlocConsumer<CombinedDateCubit2, CombinedDateState2>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = getpatientDataCubit.get(context);
          String Selected = '';
          return Directionality(
            textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr,
            child: WillPopScope(
              onWillPop: () => _onWillPop(context),
              child: Scaffold(
                appBar: CustomAppBar(title: isArabicsaved?'السجلات الطبيه':'Medical Records'),
                backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                body: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                  Row(
                    children: [
                      CustomwhiteContainer(
                        width: 70,
                        height: 50,
                        child: ReusableTextFormField(
                          keyboardType: TextInputType.number,
                          controller: patientCodeController,
                          hintText: isArabicsaved?'الكود':'Code',
                          onChanged: (value) {

                            GetPrescreptionDateCubit.get(context).updatePatientCode(value);
                            getpatientDataCubit.get(context).updatePatientCode(value);
                            GetExaminationDateCubit.get(context).updatePatientCode(value);
                            GetservicesDateCubit.get(context).updatePatientCode(value);
                            CombinedDateCubit2.get(context).updatePatientCode(value);
                            // Trigger form validation (if needed)
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      BlocBuilder<getpatientDataCubit, getpatientDataStatus>(
                        builder: (context, state) {
                          var cubit = getpatientDataCubit.get(context);
                          patientname= '${cubit.patientname2}';
                          print(patientname);
                          return Expanded(
                            child: CustomwhiteContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ConditionalBuilder(
                                  condition: state is! getpatientDataLoadingState,
                                  builder: (context) {
                                    return Text(
                                      patientCodeController.text.isEmpty
                                          ? isArabicsaved?'ادخل كود المريض':'Enter patient code'
                                          : '${cubit.patientname2}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkmodesaved ? Colors.white : Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                  fallback: (context) => const LinearProgressIndicator(),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                                  SizedBox(height: 20),
                      BlocBuilder<ChoiceChipCubit, ChoiceChipState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildChoiceChip(context, isArabicsaved?'الادويه':'Meds', state),
                              buildChoiceChip(context, isArabicsaved?'التشخيصات': 'Examinations', state),
                              buildChoiceChip(context, isArabicsaved?'الخدمات': 'Services', state),
                            ],
                          );
                        },
                      ),
                      Expanded(
                        child:
                        BlocBuilder<ChoiceChipCubit, ChoiceChipState>(
                          builder: (context, chipState) {
                            if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == '${isArabicsaved?'الادويه':'Meds'}') {
                              Selected = 'Meds';
                              if (state is CombinedDateLoadingState2) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is CombinedDateLoaded2) {
                                return BlocBuilder<GetPrescreptionDateCubit,
                                    GetPrescreptionDataStatus>(
                                  builder: (context, state) {
                                    var prescriptions = GetPrescreptionDateCubit.get(context).groupedPrescriptions;
                                    var prescription = GetPrescreptionDateCubit.get(context).allPrescriptions;
                                    if (state is GetPrescreptionDataLoadingState) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (state
                                        is GetPrescreptionDataSucessState) {
                                      print(prescriptions);
                                      return
                                        ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: prescriptions.keys.length,
                                          itemBuilder: (context, index) {
                                            final docno = prescriptions.keys.elementAt(index); // Group by docno
                                            final items = prescriptions[docno]!; // Get items by docno

                                            // Assuming all items in the same docno group share the same patient info
                                            final String name = items[0]['pat_name'].toString(); // Get patient name
                                            final String code = items[0]['code'].toString(); // Get patient code
                                            final String date = items[0]['doc_date'].toString(); // Get document date

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        name,
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        isArabicsaved?'كود المريض: $code':'Code: $code',
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                        ),
                                                      ),
                                                      Text(
                                                        date.substring(0, 10),
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: items.length,
                                                  itemBuilder: (context, subIndex) {
                                                    return Column(
                                                      children: [
                                                        PrescreptoinItem(
                                                          Prescreptoins: items[subIndex],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                Divider(),
                                              ],
                                            );
                                          },
                                        );

                                    } else if (state
                                        is GetPrescreptionDataErrorState) {
                                      return Center(
                                          child: Text('Error: ${state.error}'));
                                    } else {
                                      return Center(
                                          child: Text('No Data Available'));
                                    }
                                  },
                                );
                              } else if (state is CombinedDateError2) {
                                return Center(child: Text('Error: ${state.error}'));
                              } else {
                                return Center(child: Text('No Data Available'));
                              }
                            }
                            if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == '${isArabicsaved?'التشخيصات': 'Examinations'}') {
                              Selected = 'Meds';
                              if (state is CombinedDateLoadingState2) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is CombinedDateLoaded2) {
                                return BlocBuilder<GetExaminationDateCubit,
                                    GetExaminationDataStatus>(
                                  builder: (context, state) {
                                    var examinations =
                                        GetExaminationDateCubit.get(context)
                                            .groupedExaminations;
                                    var allExaminations = GetExaminationDateCubit.get(context).allExaminations;

                                    if (state is GetExaminationDataLoadingState) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (state
                                        is GetExaminationDataSuccessState) {
                                      return
                                        ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: examinations.keys.length,
                                          itemBuilder: (context, index) {
                                            final docno = examinations.keys.elementAt(index); // Group by doc_no
                                            final items = examinations[docno]!; // Get items by doc_no

                                            // Assuming all items in the same doc_no group share the same patient info
                                            final String name = items[0]['pat_name'].toString(); // Get patient name
                                            final String code = items[0]['code'].toString(); // Get patient code
                                            final String date = items[0]['doc_date'].toString(); // Get document date

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        name,
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        isArabicsaved?'كود المريض: $code':'Code: $code',
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                        ),
                                                      ),
                                                      Text(
                                                        date.substring(0, 10),
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: items.length,
                                                  itemBuilder: (context, subIndex) {
                                                    return Column(
                                                      children: [
                                                        ExaminationItem(
                                                          Examination: items[subIndex],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                Divider(),
                                              ],
                                            );
                                          },
                                        )
                                      ;
                                    } else if (state
                                        is GetExaminationDataErrorState) {
                                      return Center(
                                          child: Text('Error: ${state.error}'));
                                    } else {
                                      return Center(
                                          child: Text('No Data Available'));
                                    }
                                  },
                                );
                              } else if (state is CombinedDateError2) {
                                return Center(child: Text('Error: ${state.error}'));
                              } else {
                                return Center(child: Text('No Data Available'));
                              }
                            }
                            if (chipState is ChoiceChipSelected &&
                                chipState.selectedChoice == '${isArabicsaved?'الخدمات': 'Services'}') {
                              Selected = 'Services';
                              if (state is CombinedDateLoadingState2) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is CombinedDateLoaded2) {
                                return BlocBuilder<GetservicesDateCubit, GetServiceDataStatus>(
                                  builder: (context, state) {
                                    var services = GetservicesDateCubit.get(context).groupedServices;
                                    var allservices = GetservicesDateCubit.get(context).allServices;

                                    if (state is GetServiceDataLoadingState) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (state
                                        is GetServiceDataSuccessState) {
                                      return
                                        ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: services.keys.length,
                                          itemBuilder: (context, index) {
                                            final docno = services.keys.elementAt(index); // Group by doc_no
                                            final items = services[docno]!; // Get services by doc_no

                                            // Assuming all items in the same doc_no group share the same service info
                                            final String patientName = items[0]['pat_name'].toString(); // Get patient name
                                            final String code = items[0]['code'].toString(); // Get patient code
                                            final String date = items[0]['doc_date'].toString(); // Get document date

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        patientName,
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        isArabicsaved?'كود المريض: $code':'Code: $code',
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                        ),
                                                      ),
                                                      Text(
                                                        date.substring(0, 10),
                                                        style: TextStyle(
                                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: items.length,
                                                  itemBuilder: (context, subIndex) {
                                                    return Column(
                                                      children: [
                                                        ServiceItem(
                                                           Service: items[subIndex],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                Divider(),
                                              ],
                                            );
                                          },
                                        )
                                      ;
                                    } else if (state is GetServiceDataErrorState) {
                                      return Center(
                                          child: Text('Error: ${state.error}'));
                                    } else {
                                      return Center(
                                          child: Text('No Data Available'));
                                    }
                                  },
                                );
                              } else if (state is CombinedDateError2) {
                                return Center(child: Text('Error: ${state.error}'));
                              } else {
                                return Center(child: Text('No Data Available'));
                              }
                            } else {
                              Selected = 'Meds';
                              if (state is CombinedDateLoadingState2) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is CombinedDateLoaded2) {
                                return BlocBuilder<CombinedDateCubit2,
                                    CombinedDateState2>(
                                  builder: (context, state) {
                                    if (state is CombinedDateLoadingState2) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (state is CombinedDateLoaded2) {
                                      return ListView.builder(

                                        itemCount:
                                            state.groupedDateCodePairs.length,
                                        itemBuilder: (context, index) {
                                          final group =
                                              state.groupedDateCodePairs[index];
                                          return Column(
                                            children: [
                                              Card(

                                                child: CustomwhiteContainer(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    child: GestureDetector(
                                                      child: ExpansionTile(

                                                         shape: BeveledRectangleBorder(side: BorderSide.none),
                                                        iconColor:isDarkmode? Colors.white:Colors.black54 ,
                                                        collapsedIconColor: isDarkmode? Colors.white:Colors.black54,
                                                        collapsedBackgroundColor: isDarkmodesaved ? Colors.grey[700] : Colors.white,
                                                        backgroundColor: isDarkmodesaved ? Colors.grey[700] : Colors.white,
                                                        title: Column(crossAxisAlignment: CrossAxisAlignment.start,

                                                          children: [
                                                            Text(
                                                              '${group.dateCodePairs.first.patName}',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkmode ? Colors.white : Colors.black54,
                                                              ),
                                                            ),
                                                            Text(
                                                              isArabicsaved?'كود المريض: ${group.dateCodePairs.first.code}':'Code: ${group.dateCodePairs.first.code}',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                                color: isDarkmode ? Colors.white : Colors.black54,
                                                              ),
                                                            ),
                                                            Text(
                                                              isArabicsaved?'التاريخ: ${group.dateCodePairs.first.docDate.substring(0, 10)}':'Date: ${group.dateCodePairs.first.docDate.substring(0, 10)}',

                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400,
                                                                color: isDarkmode ? Colors.white : Colors.black54,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    ...group.dateCodePairs.map((pair) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                        child: Container(
                                                                          width: MediaQuery.of(context).size.width * 0.7, // Adjust width as needed
                                                                          child: Text(
                                                                            '${pair.date}',
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(
                                                                              color: isDarkmodesaved ? Colors.white : Colors.black54,
                                                                              fontSize: 12,
                                                                            ),
                                                                            overflow: TextOverflow.ellipsis, // Handle long text
                                                                            maxLines: 1, // Ensure the text stays within one line
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    SizedBox(height: 5),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      onLongPress: () {
                                                        print('${group.dateCodePairs.first.docno}');
                                                        navigateToPage(context, UpdateMedicalRecords(docno: group.dateCodePairs.first.docno));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                               SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          );
                                          ;
                                        },
                                      );

                                      ;
                                    } else if (state is CombinedDateError2) {
                                      return Center(
                                          child: Text('Error: ${state.error}'));
                                    } else {
                                      return Center(
                                          child: Text('No Data Available'));
                                    }
                                  },
                                );
                              } else if (state is CombinedDateError2) {
                                return Center(child: Text('Error: ${state.error}'));
                              } else {
                                return Center(child: Text('No Data Available'));
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: GestureDetector(
                  onTap: () {
                    if (patientCodeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patient code cannot be empty')),
                      );
                      return;
                    } if('${cubit.patientname2}' == 'Patient not existed ') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patient not existed')),
                      );
                      return;

                    }
                    else{
                      switch (Selected) {
                        case 'Meds':
                          serviceonly = false;
                          navigateToPage(context, addnew());
                          break;
                        case 'Meds':
                          serviceonly = false;
                          navigateToPage(context, addnew());
                          break;
                        case 'Services':
                          serviceonly = true;
                          navigateToPage(context, Services());
                          break;
                        default:
                          serviceonly = false;
                          navigateToPage(context, addnew());
                          break;
                      }

                    }
                      },
                  child: CustomblueContainer(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
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
  Future<bool> _onWillPop(BuildContext context) async {
    // Navigate to BookingList when back button is pressed
    navigateToPage(context, Home());
    return false; // Prevent the default back navigation
  }
}
