

import 'package:flutter/cupertino.dart';

import '../Cubits/cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
class LoadingNewUser extends getLoginDataStates {}
class SuccessNewUser extends getLoginDataStates {}
class submet extends getLoginDataStates {}
class getLoginDataSucessState extends getLoginDataStates {
  final List<Map<String, dynamic>> Data;
  getLoginDataSucessState(this.Data);
}
class getLoginDataErrorState extends getLoginDataStates {
  final String error;
  getLoginDataErrorState(this.error);
}
class ErrorNewUser extends getLoginDataStates {
  final String error;
  ErrorNewUser(this.error);
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
class NewDoctorLoadingState extends getDoctorDataStatus {}
class NewDoctorSucessState extends getDoctorDataStatus {}
class getDoctorDataErrorState extends getDoctorDataStatus {
  final String error;

  getDoctorDataErrorState(this.error);
}
class NewDoctorErrorState extends getDoctorDataStatus {
  final String error;

  NewDoctorErrorState(this.error);
}
//..............................................................................

abstract class getDrugsDataStatus {}

class getDrugsDataLoadingState extends getDrugsDataStatus {}
class getDrugsDataInitState extends getDrugsDataStatus {}
class getDrugsDataSucessState extends getDrugsDataStatus {
  final List<Map<String, dynamic>> Drugs;

  getDrugsDataSucessState(this.Drugs);
}
class getDrugsDataErrorState extends getDrugsDataStatus {
  final String error;

  getDrugsDataErrorState(this.error);
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

  List<Object> get props => [];
}

class AnimationInitialState extends AnimationState {}
class AnimationExpandedState extends AnimationState {}
class AnimationExpanded2State extends AnimationState {}
class AnimationCollapsedState extends AnimationState {}
class AnimationCollapsed2State extends AnimationState {}
//............................................................................
abstract class ChoiceChipState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChoiceChipInitial extends ChoiceChipState {}
class ChoiceChipSelected extends ChoiceChipState {
   String selectedChoice ='';

  ChoiceChipSelected(this.selectedChoice);

  @override
  List<Object> get props => [selectedChoice];
}

//............................................................................
class MedsState {
  final List<TextEditingController> controllers;
  final List<TextEditingController> timesPerDayControllers;
  final List<TextEditingController> daysControllers;
  final List<Map<String, String>> medications;
  final String? error;

  MedsState({
    required this.controllers,
    required this.timesPerDayControllers,
    required this.daysControllers,
    required this.medications,
    this.error,
  });

  factory MedsState.initial() {
    return MedsState(
      controllers: [TextEditingController()],
      timesPerDayControllers: [TextEditingController()],
      daysControllers: [TextEditingController()],
      medications: [],
      error: null,
    );
  }

  MedsState copyWith({
    List<TextEditingController>? controllers,
    List<TextEditingController>? timesPerDayControllers,
    List<TextEditingController>? daysControllers,
    List<Map<String, String>>? medications,
    String? error,
  }) {
    return MedsState(
      controllers: controllers ?? this.controllers,
      timesPerDayControllers: timesPerDayControllers ?? this.timesPerDayControllers,
      daysControllers: daysControllers ?? this.daysControllers,
      medications: medications ?? this.medications,
      error: error,
    );
  }
}
class RecordsState {
  final List<TextEditingController> controllers;
  final List<Map<String, String>> Records;
  final String? error;

  RecordsState({
    required this.controllers,
    required this.Records,
    this.error,
  });

  RecordsState copyWith({
    List<TextEditingController>? controllers,

    List<Map<String, String>>? Records,
    String? error,
  }) {
    return RecordsState(
      controllers: controllers ?? this.controllers,
      Records: Records ?? this.Records,
      error: error,
    );
  }
}
class ServicesState {
  final List<TextEditingController> controllers;
  final List<Map<String, String>> Services;
  final String? error;

  ServicesState({
    required this.controllers,
    required this.Services,
    this.error,
  });

  ServicesState copyWith({
    List<TextEditingController>? controllers,

    List<Map<String, String>>? Services,
    String? error,
  }) {
    return ServicesState(
      controllers: controllers ?? this.controllers,
      Services: Services ?? this.Services,
      error: error,
    );
  }
}


//............................................................................
abstract class HomeState {}
class HomeInitial extends HomeState {}
//............................................................................
abstract class GetPrescreptionDataStatus {}

class GetPrescreptionDataInitState extends GetPrescreptionDataStatus {}
class GetPrescreptionDataLoadingState extends GetPrescreptionDataStatus {}
class newPrescreptionSuccessState extends GetPrescreptionDataStatus {}
class GetPrescreptionDataSucessState extends GetPrescreptionDataStatus {
  final Map<String, List<dynamic>> prescriptions;

  GetPrescreptionDataSucessState(this.prescriptions);
}
class GetPrescreptionDataErrorState extends GetPrescreptionDataStatus {
  final String error;

  GetPrescreptionDataErrorState(this.error);
}
//............................................................................
abstract class GetExaminationDataStatus {}

class GetExaminationDataInitState extends GetExaminationDataStatus {}
class GetExaminationDataLoadingState extends GetExaminationDataStatus {}
class GetExaminationDataSuccessState extends GetExaminationDataStatus {
  final Map<String, List<dynamic>> groupedExaminations;

  GetExaminationDataSuccessState(this.groupedExaminations);
}
class GetExaminationDataErrorState extends GetExaminationDataStatus {
  final String error;

  GetExaminationDataErrorState(this.error);
}
//............................................................................
abstract class GetServiceDataStatus {}
class GetServiceDataInitState extends GetServiceDataStatus {}
class GetServiceDataLoadingState extends GetServiceDataStatus {}
class GetServiceDataSuccessState extends GetServiceDataStatus {
  final Map<String, List<dynamic>> groupedServices;

  GetServiceDataSuccessState(this.groupedServices);
}
class GetServiceDataErrorState extends GetServiceDataStatus {
  final String error;

  GetServiceDataErrorState(this.error);
}
//............................................................................
//............................................................................
//............................................................................
abstract class CombinedDataState {}

class GetSurgerysDataInitState extends CombinedDataState {}
class GetSurgerysDataLoadingState extends CombinedDataState {}
class GetSurgerysDataSucessState extends CombinedDataState {
  final Map<String, List<dynamic>> Surgerys;

  GetSurgerysDataSucessState(this.Surgerys);
}
class GetSurgerysDataErrorState extends CombinedDataState {
  final String error;

  GetSurgerysDataErrorState(this.error);
}
class CombinedDataInitial extends CombinedDataState {}
class CombinedDataLoadingState extends CombinedDataState {}
class CombinedDataLoaded extends CombinedDataState {
  final Map<String, List<dynamic>> groupedPrescriptions;
  final Map<String, List<dynamic>> groupedRecords;
  final Map<String, List<dynamic>> groupedServices;
  final Map<String, List<dynamic>> groupedMedrec4;
  final Map<String, List<dynamic>> groupedSurgerys;

  CombinedDataLoaded({
    required this.groupedPrescriptions,
    required this.groupedRecords,
    required this.groupedServices,
    required this.groupedMedrec4,
    required this.groupedSurgerys,
  });
}
class CombinedDataError extends CombinedDataState {
  final String error;
  CombinedDataError(this.error);
}
class GetMedrec4DataInitState extends CombinedDataState {}
class GetMedrec4DataLoadingState extends CombinedDataState {}
class GetMedrec4DataSucessState extends CombinedDataState {
  final Map<String, List<dynamic>> Medrec4;

  GetMedrec4DataSucessState(this.Medrec4);
}
class GetMedrec4DataErrorState extends CombinedDataState {
  final String error;

  GetMedrec4DataErrorState(this.error);
}
class GetservicesDataInitState extends CombinedDataState {}
class GetservicesDataLoadingState extends CombinedDataState {}
class GetservicesDataSucessState extends CombinedDataState {
  final Map<String, List<dynamic>> services;

  GetservicesDataSucessState(this.services);
}
class GetservicesDataErrorState extends CombinedDataState {
  final String error;

  GetservicesDataErrorState(this.error);
}
//............................................................................
abstract class CombinedDateState {}

class CombinedDateInitial extends CombinedDateState {}
class CombinedDateLoadingState extends CombinedDateState {}
class CombinedDateLoaded extends CombinedDateState {
  final List<String> combinedDates;
  CombinedDateLoaded(this.combinedDates);
}
class CombinedDateError extends CombinedDateState {
  final String error;
  CombinedDateError(this.error);
}
//............................................................................
abstract class CombinedDateState2 {}

class CombinedDateInitial2 extends CombinedDateState2 {}
class CombinedDateLoadingState2 extends CombinedDateState2 {}
class CombinedDateLoaded2 extends CombinedDateState2 {
  final List<GroupedDateCodePair> groupedDateCodePairs;
  CombinedDateLoaded2(this.groupedDateCodePairs);
}
class CombinedDateError2 extends CombinedDateState2 {
  final String error;

  CombinedDateError2(this.error);
}
//............................................................................
abstract class ShowPasswordStatus {}
class ShowPasswordState extends ShowPasswordStatus{}
class HidePasswordState extends ShowPasswordStatus{}
//............................................................................
// States.dart
abstract class UploadImageState {}

class UploadImageInitialState extends UploadImageState {
  final String? imagePath;
  UploadImageInitialState({this.imagePath});
}

class UploadImageLoadingState extends UploadImageState {}

class UploadImageSuccessState extends UploadImageState {
  final String imagePath;
  UploadImageSuccessState({required this.imagePath});
}

class UploadImageErrorState extends UploadImageState {
  final String error;
  UploadImageErrorState({required this.error});
}
