import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class DrugClinicCubit extends Cubit<DrugClinicState> {
  final Dio _dio;

  DrugClinicCubit(this._dio) : super(DrugClinicInitialState());

  Future<void> fetchDrugClinicData() async {
    emit(DrugClinicLoadingState());
    try {
      final response = await _dio.get('http://192.168.1.88/api/drugClinic/filtered');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        List<DrugClinic> drugList = data.map((json) => DrugClinic.fromJson(json)).toList();
        emit(DrugClinicSuccessState(drugList));
      } else {
        emit(DrugClinicErrorState('Failed to fetch data'));
      }
    } catch (error) {
      emit(DrugClinicErrorState('An error occurred: $error'));
    }
  }
}

abstract class DrugClinicState {}

class DrugClinicInitialState extends DrugClinicState {}

class DrugClinicLoadingState extends DrugClinicState {}

class DrugClinicSuccessState extends DrugClinicState {
  final List<DrugClinic> drugList;

  DrugClinicSuccessState(this.drugList);
}

class DrugClinicErrorState extends DrugClinicState {
  final String errorMessage;

  DrugClinicErrorState(this.errorMessage);
}

class DrugClinic {
  final int noo;
  final String eDesc;
  final int idClinic;

  DrugClinic({
    required this.noo,
    required this.eDesc,
    required this.idClinic,
  });

  factory DrugClinic.fromJson(Map<String, dynamic> json) {
    return DrugClinic(
      noo: json['noo'] ?? 0,
      eDesc: json['E_DESC'] ?? '',
      idClinic: json['id_clinic'] ?? 0,
    );
  }
}
