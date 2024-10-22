import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';
import '../../shared/componants.dart';

class BasicDataServicess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GEtServicesCubit(Dio())..fetchServicesData(),
      child: BlocBuilder<GEtServicesCubit, ServicesDataState>(
        builder: (context, state) {
          final cubit = context.read<GEtServicesCubit>();
          var Services = cubit.Services ?? [];

          return Scaffold(
            backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
            body: ConditionalBuilder(
              condition: state is! ServicesDataLoadingState,
              builder: (context) {
                if (state is ServicesDataErrorState) {
                  return Center(
                    child: Text(
                      'Network Error: ${state.errorMessage}',
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
                  itemCount: Services.length,
                  itemBuilder: (context, index) {
                    final Servicesindex = Services[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomwhiteContainer(child: ServicesDataItem(Services: Servicesindex)),
                    );
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
