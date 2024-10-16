import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/test/user_bloc.dart';

class DrugClinicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrugClinicCubit(Dio())..fetchDrugClinicData(),
      child: BlocBuilder<DrugClinicCubit, DrugClinicState>(
        builder: (context, state) {
          if (state is DrugClinicLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DrugClinicSuccessState) {
            final drugList = state.drugList;
            return ListView.builder(
              itemCount: drugList.length,
              itemBuilder: (context, index) {
                final drug = drugList[index];
                return ListTile(
                  title: Text(drug.eDesc),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Clinic ID: ${drug.idClinic}"),
                    ],
                  ),
                );
              },
            );
          } else if (state is DrugClinicErrorState) {
            print(state.errorMessage,);
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
      ),
    );
  }
}
