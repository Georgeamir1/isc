import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/State_manage/States/States.dart';
import 'package:isc/network/dio_helper.dart';
import '../../Screens/Booking/Booking_list.dart';
import '../../shared/Data.dart';
//..............................................................................

class getDataCubit extends Cubit<getLoginDataStates> {
  List<Map<String, dynamic>> _users = [];
  String? selectedUser;
  String? selectedUserPassword;
  getDataCubit() : super(getLoginDataInitialState());

  static getDataCubit get(context) => BlocProvider.of(context);

  void getdata() async {
    try {
      emit(getLoginDataLoadingState());
      final response = await DioHelper.getData(url: 'http://192.168.1.198/api/Doctor/');
      final data = response.data;
      _users = List<Map<String, dynamic>>.from(data);
      emit(getLoginDataSucessState(_users));
    } catch (e) {
      emit(getLoginDataErrorState(e.toString()));
    }
  }
  void selectUser(String userName) {
    selectedUser = userName;
    selectedUserPassword = _users.firstWhere((user) => user['NAME'] == userName)['psw'] as String?;
    doubleselectedUserID = _users.firstWhere((user) => user['NAME'] == userName)['DOC'] ;
    Doctorspecialty = _users.firstWhere((user) => user['NAME'] == userName)['insip_name'] ;
    Doctorname =_users.firstWhere((user) => user['NAME']== userName)['NAME'];
    StringselectedUserID = doubleselectedUserID?.toString() ;
    print(selectedUserPassword);
    print(Doctorspecialty);

    emit(getLoginDataSucessState(_users));
  }
  bool validatePassword(String password) {
    if (selectedUserPassword == null) return false;
    {
      return selectedUserPassword == password;

    }
  }
  void submitForm(String password, BuildContext context) {
    if (selectedUser == null) {
      emit(getLoginDataErrorState('Please select a user.'));
    } else if (validatePassword(password)) {
      emit(getLoginDataSuccessMessage('Password is correct!'));
      // Navigate to BookingList
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingList()),
      );
    } else {
      emit(getLoginDataErrorState('Password is incorrect!'));
    }
  }

}
//..............................................................................

class getDoctorDataCubit extends Cubit<getDoctorDataStatus> {
  getDoctorDataCubit() :super(getDoctorDataInitState());
  static getDoctorDataCubit get(context) =>BlocProvider.of(context);
  List<dynamic> Doctors = [];

  String errormessage = '';
  getDoctorDataCubit.DoctorDataCubit() : super(getDoctorDataInitState());
  void getdata() async {
    String url = 'http://192.168.1.198/api/secudleout/filtered';
    try {
      emit(getDoctorDataLoadingState());

      // Fetch data logic here
      final response =
      await DioHelper.
      getData(url: url);
       Doctors = response.data;


      print(url);
      emit(getDoctorDataSucessState(Doctors));
    } catch (e) {
      print('Error: ${e}');
       errormessage = 'Network Error';
      emit(getDoctorDataErrorState(e.toString()));
    }
  }


}

//..............................................................................
class getpatientDataCubit extends Cubit<getpatientDataStatus> {
  getpatientDataCubit() : super(getpatientDataInitState());

  static getpatientDataCubit get(BuildContext context) => BlocProvider.of(context);

  Map<String, dynamic>? patients;
  String? patientname = 'اكتب كود المريض';
  String errormessage = '';
  String? patientcode;

  void updatePatientCode(String value) {
    patientcode = value;
    getdata();
  }

  void getdata() async {
    if (patientcode == null || patientcode!.isEmpty) return;

    String url = 'http://192.168.1.198/api/Patient/filtered/$patientcode';
    try {
      emit(getpatientDataLoadingState());

      final response = await DioHelper.getData(url: url);
      patients = response.data;
      patientname = patients?["NAME"];
      print(patientname);

      emit(getpatientDataSucessState(patients!));
    } catch (e) {
      errormessage = 'Network Error';
      emit(getpatientDataErrorState(e.toString()));
    }
  }
}

//..............................................................................

class BookingCubit extends Cubit<Bookingtatus> {

  static BookingCubit get(BuildContext context) => BlocProvider.of(context);
  BookingCubit() : super(BookingInitState());
  bool _isOption1Selected= false;
  Map<String, dynamic>? _data;

  void newBookin({
    required String? time,
    required String ? contact,
    required String ? name,
    required String ? patcode,
    required String ? DayType,
    required String ? Contact,
    required bool ? again,
}) {
  emit(BookingLoadingState());
  DioHelper.postData(
      url: 'http://192.168.1.198/api/SecudleOut',
      data:
      {
       'OPERATOR':Doctorname,
       'op_code':StringselectedUserID,
       'SDATE':Date,
        'PATIENT':name,
        'cconfirm':false,
        'oper_roomt':"${again == false ?'كشف':'اعاده'}",
        'pat_code':patcode,
        'day_typ': DayType,
        'cont_name': Contact,


      } ).catchError((error)
  {print(error);
    emit(BookingErrorState(error.toString()));});
}
  void toogel() {
    _isOption1Selected =!_isOption1Selected;

    emit(Bookingswitchstate(_isOption1Selected));
  }
  void editBookin({
    required String? No,
     String ? patcode,
     String ? Contact,
     bool ? again,
  }) {
    emit(BookingLoadingState());
    DioHelper.putData(
        url: 'http://192.168.1.198/api/SecudleOut/$selectedNo',
        data:
        {
          'SDATE':Date,
          'oper_roomt':"${again == false ?'كشف':'اعاده'}",
          'pat_code':patcode,
          'cont_name': Contact,
        } ).catchError((error)
    {print(error);
    emit(BookingErrorState(error.toString()));});
  }
  void getBookindata() async {
    try {
      emit(BookingLoadingState());
      final response = await DioHelper.getData(url: 'http://192.168.1.198/api/secudleout/$selectedNo');
       _data = response.data ;
       patientcode = "${_data?['pat_code']}";
      emit(BookingSucessState());
    } catch (e) {
      print(e);
      emit(BookingErrorState(e.toString()));
    }
  }
}



//..............................................................................
class getContactDataCubit extends Cubit<getContactDataStates> {
  List<String> Contacts = [];

  getContactDataCubit() : super(getContactDataInitialState());

  static getContactDataCubit get(context) => BlocProvider.of(context);

  void getdata() async {
    try {
      emit(getContactDataLoadingState());
      final response = await DioHelper.getData(url: 'http://192.168.1.198/api/Contact/filtered');
      final data = response.data as List<dynamic>;
      Contacts = data.map<String>((contact) => contact['NAME'] as String).toList();
      emit(getContactDataSucessState(Contacts));
    } catch (e) {
      emit(getContactDataErrorState(e.toString()));
    }
  }

  void selectUser(String contact) {
    SelectedContact = contact;
    print(SelectedContact);
    emit(getContactDataSucessState(Contacts));
  }
}
