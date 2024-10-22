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


class AddNewService extends StatelessWidget {
  final TextEditingController Mwds = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  TextEditingController ExaminationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getDrugsDataCubit()..getServicedata()),
        BlocProvider(create: (BuildContext context) => MedsCubit()),
      ],
      child: BlocConsumer<MedsCubit, MedsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _getLocalizedText(
                      isArabicsaved, 'Error: ${state.error!}', 'خطأ: ${state.error!}'),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: Directionality(
              textDirection: isArabicsaved ? TextDirection.rtl : TextDirection.ltr,

              child: Scaffold(
                appBar: CustomAppBar(
                  title: _getLocalizedText(isArabicsaved, 'Add new Service', 'اضافه خدمه جديد'),
                ),
                backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
                body: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          _getLocalizedText(isArabicsaved, 'Services', 'الخدمات'),
                          style: TextStyle(
                            color: isDarkmodesaved ? Colors.white : Colors.black45,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<MedsCubit, MedsState>(
                          builder: (context, state) {
                            final controllers = state.controllers;
                            return Screenshot(
                              controller: screenshotController,
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controllers.length,
                                    itemBuilder: (context, index) {
                                      final controller = controllers[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: NewServiceItem(
                                          nameController: controller,
                                          index: index,
                                          // For TextFields inside NewExaminationItem,
                                          // ensure textDirection is set to RTL when `isArabicsaved`
                                        ),
                                      );
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
                                          context.read<MedsCubit>().addMed();
                                        },
                                      ),
                                      Text(
                                        _getLocalizedText(isArabicsaved, 'New Service', 'خدمة جديدة'),
                                        style: TextStyle(
                                          color: isDarkmodesaved ? Colors.white : Colors.black45,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
          content: Text(_getLocalizedText(isArabicsaved, 'No controllers available to add medication', 'لا يوجد أدوية لإضافتها')),
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
          content: Text(_getLocalizedText(isArabicsaved, 'Medication name cannot be empty', 'اسم الدواء لا يمكن أن يكون فارغاً')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isDuplicate = currentState.medications.any((med) => med['name'] == newMedicationName);

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getLocalizedText(isArabicsaved, 'Medication is duplicated', 'الدواء مكرر')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Fetch the initial list of services
    List<Map<String, dynamic>> services = await context.read<getDrugsDataCubit>().Services;
    int? noo = services.length;
    bool exists = false;

    for (var med in medications) {
      exists = services.any((service) => service['A_DESC'] == med['name']);
      if (!exists) {
        await context.read<getDrugsDataCubit>().NewService(
          PARTNO: (noo! + 1),
          SerName: med['name'],
        );

        services = await context.read<getDrugsDataCubit>().Services;
        noo++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getLocalizedText(isArabicsaved, 'Service (${med['name']}) already exists', 'الخدمة (${med['name']}) موجودة بالفعل')),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }

    context.read<getDrugsDataCubit>().getServicedata();
    navigateToPage(context, Basicdata());
  }

  Future<bool> _onWillPop(BuildContext context) async {
    navigateToPage(context, Basicdata());
    return false;
  }

  // Helper function to get localized text
  String _getLocalizedText(bool isArabic, String englishText, String arabicText) {
    return isArabic ? arabicText : englishText;
  }
}
