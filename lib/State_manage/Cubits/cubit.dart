import 'dart:core';
import 'dart:ffi';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/State_manage/States/States.dart';
import 'package:isc/network/dio_helper.dart';
import 'package:isc/network/end_points.dart';
import 'package:isc/shared/componants.dart';
import '../../network/login_model.dart';
import '../../shared/Data.dart';
//..............................................................................

class getDataCubit extends Cubit<getLoginDataStates> {
  List<Map<String, dynamic>> _users = [];
  String? selectedUser;
  String? selectedUserPassword;

  getDataCubit.LoginCubit() : super(getLoginDataInitialState());

  void getdata() async {
    try {
      emit(getLoginDataLoadingState());
      // Fetch data logic here
      final response =
          await DioHelper.getData(url: 'http://192.168.1.11/api/users/active/');
      final data = response.data;
      _users = List<Map<String, dynamic>>.from(data);
      emit(getLoginDataSucessState(_users));
    } catch (e) {
      print('Error: ${e}');
      emit(getLoginDataErrorState(e.toString()));
      print('Error: ${e}');
    }
  }
  void selectUser(String userName) {
    selectedUser = userName;
    selectedUserPassword = _users.firstWhere(
        (user) => user['UserName'] == userName)['UserPassword'] as String?;
    selectedUserID = _users.firstWhere((user) => user['ID'] == userName)['ID'];
    selectedUser = _users.firstWhere(
        (user) => user['UserName'] == userName)['UserPassword'] as String?;
    emit(getLoginDataSucessState(_users));
  }
  bool validatePassword(String password) {
    if (selectedUserPassword == null) return false;
    return selectedUserPassword == password;
  }
}

//..............................................................................

class getDoctorDataCubit extends Cubit<getDoctorDataStatus> {
  getDoctorDataCubit() :super(getDoctorDataInitState());
  static getDoctorDataCubit get(context) =>BlocProvider.of(context);
  List<dynamic> Doctors = [];
  String errormessage = '';
  Int ?patcode;
  String? patname;
  String? Doctorname;
  String? OperRoomt;
  String? SDate;

  getDoctorDataCubit.DoctorDataCubit() : super(getDoctorDataInitState());
  void getdata() async {
    try {
      emit(getDoctorDataLoadingState());

      // Fetch data logic here
      final response =
      await DioHelper.
      getData(url: 'http://192.168.1.198/api/secudleout/');
       Doctors = response.data;
      emit(getDoctorDataSucessState(Doctors));
    } catch (e) {
      print('Error: ${e}');
       errormessage = 'Network Error';
      emit(getDoctorDataErrorState(e.toString()));
    }
  }


}

//..............................................................................

class BookingCubit extends Cubit<getDoctorDataStatus> {
  BookingCubit.DoctorDataCubit() : super(getDoctorDataInitState());
}

//..............................................................................
