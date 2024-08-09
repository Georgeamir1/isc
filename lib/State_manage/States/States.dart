import 'package:isc/network/login_model.dart';
//..............................................................................

abstract class loginStates {}
  class loginInitState extends loginStates {}
  class loginLoadingState extends loginStates {}
  class loginSucessState extends loginStates {}
  class loginErrorState extends loginStates {
  final String error;

  loginErrorState(this.error);
}

//..............................................................................

abstract class getLoginDataStates {}
  class getLoginDataSucessState extends getLoginDataStates {
  final List<Map<String, dynamic>> Data;

  getLoginDataSucessState(this.Data);
}
  class getLoginDataErrorState extends getLoginDataStates {
  final String error;

  getLoginDataErrorState(this.error);
}
  class getLoginDataInitialState extends getLoginDataStates {}
  class getLoginDataLoadingState extends getLoginDataStates {}
  class PasswordValidationState extends getLoginDataStates {
  final bool isValid;

  PasswordValidationState(this.isValid);
}

//..............................................................................

abstract class getDoctorDataStatus {}
  class getDoctorDataInitState extends getDoctorDataStatus {}
  class getDoctorDataLoadingState extends getDoctorDataStatus {}
  class getDoctorDataSucessState extends getDoctorDataStatus {
  getDoctorDataSucessState(List<dynamic> Doctors );
}
  class getDoctorDataErrorState extends getDoctorDataStatus {
  final String error;

  getDoctorDataErrorState(this.error);
}

//..............................................................................

abstract class Bookingtatus {}
  class BookingInitState extends Bookingtatus {}
  class BookingLoadingState extends Bookingtatus {}
  class BookingCancelState extends Bookingtatus {}
  class BookingucessState extends Bookingtatus {}
  class BookingErrorState extends Bookingtatus {
  final String error;

  BookingErrorState(this.error);
}

//..............................................................................
