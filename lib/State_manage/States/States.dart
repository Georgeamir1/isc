import 'package:isc/network/login_model.dart';
import 'package:isc/shared/Data.dart';
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

class getLoginDataInitialState extends getLoginDataStates {}

class getLoginDataLoadingState extends getLoginDataStates {}
class submet extends getLoginDataStates {}

class getLoginDataSucessState extends getLoginDataStates {
  final List<Map<String, dynamic>> Data;
  getLoginDataSucessState(this.Data);
}

class getLoginDataErrorState extends getLoginDataStates {
  final String error;
  getLoginDataErrorState(this.error);
}

class getLoginDataSuccessMessage extends getLoginDataStates {
  final String message;
  getLoginDataSuccessMessage(this.message);
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
abstract class getpatientDataStatus {}
class getpatientDataInitState extends getpatientDataStatus {}
class getpatientDataLoadingState extends getpatientDataStatus {}
class newpatientSuccessState extends getpatientDataStatus {}
class getpatientDataSucessState extends getpatientDataStatus {
  getpatientDataSucessState(Map<String, dynamic> patients );
}
class getpatientTableSucessState extends getpatientDataStatus {
  int  lenth;
  getpatientTableSucessState(this.lenth );
}
class getpatientDataErrorState extends getpatientDataStatus {
  final String error;

  getpatientDataErrorState(this.error);
}

//..............................................................................

abstract class Bookingtatus {}
class BookingInitState extends Bookingtatus {}
class BookingLoadingState extends Bookingtatus {}
class BookingaddedState extends Bookingtatus {}
class BookingSucessState extends Bookingtatus {}
class Bookingswitchstate extends Bookingtatus {
  final bool isSelected;

  Bookingswitchstate(this.isSelected);
}
class editBookingswitchstate extends Bookingtatus {
   final bool isSelected ;

  editBookingswitchstate(this.isSelected);
}
class BookingErrorState extends Bookingtatus {
  final String error;

  BookingErrorState(this.error);
}

//..............................................................................
abstract class getContactDataStates {}
class getContactDataInitialState extends getContactDataStates {}
class getContactDataLoadingState extends getContactDataStates {}
class getContactDataSucessState extends getContactDataStates {
  final List<String> Contacts;

  getContactDataSucessState(this.Contacts);
}
class getContactDataErrorState extends getContactDataStates {
  final String error;

  getContactDataErrorState(this.error);
}
//..............................................................................
abstract class SelectDateState {}

class SelectDateInitialState extends SelectDateState {
  final DateTime initialDate;

  SelectDateInitialState(this.initialDate);
}

class SelectDateChangedState extends SelectDateState {
  final DateTime selectedDate;

  SelectDateChangedState(this.selectedDate);
}

class SelectDateClearedState extends SelectDateState {}
//............................................................................
abstract class AnimationState {
  const AnimationState();

  @override
  List<Object> get props => [];
}

class AnimationInitialState extends AnimationState {}

class AnimationExpandedState extends AnimationState {}
class AnimationExpanded2State extends AnimationState {}

class AnimationCollapsedState extends AnimationState {}
class AnimationCollapsed2State extends AnimationState {}
