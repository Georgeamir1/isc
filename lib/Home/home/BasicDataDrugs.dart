import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';

class BasicDataDrugs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrugClinicCubit(Dio())..fetchDrugClinicData(),
      child:        BlocBuilder<DrugClinicCubit, DrugClinicState>(
        builder: (context, state) {
          if (state is DrugClinicLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state is DrugClinicSuccessState) {
            final drugList = state.drugList;
            return ListView.builder(
              itemCount: drugList.length,
              itemBuilder: (context, index) {
                final drug = drugList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomwhiteContainer(
                    child: Column(
                      children: [
                        CustomText(Textdata: drug.eDesc,color: Colors.black54,fontSize: 20,fontWeight: FontWeight.bold,),
                        CustomText(Textdata: "Drug no: ${drug.noo}",),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          else if (state is DrugClinicErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),);
  }
}
