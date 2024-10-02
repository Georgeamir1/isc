import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';

class BasicdataDoctors extends StatelessWidget {
  final TextEditingController patientCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getDoctorDataCubit()..getDoctors(),
      child: BlocBuilder<getDoctorDataCubit, getDoctorDataStatus>(
        builder: (context, state) {
          final cubit = context.read<getDoctorDataCubit>();
          var patients = cubit.Doctors ?? [];

          return Scaffold(
            backgroundColor:
                isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
            body: ConditionalBuilder(
              condition: state is! getDoctorDataLoadingState,
              builder: (context) {
                if (state is getDoctorDataErrorState) {
                  return Center(
                    child: Text(
                      'Network Error',
                      style: TextStyle(
                        color: Color(0xFFbd0000),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return Doctorsitem(patient: patient);
                  },
                );
              },
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
