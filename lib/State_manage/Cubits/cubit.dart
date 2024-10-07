import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/Home/home/Home.dart';
import 'package:isc/State_manage/States/States.dart';
import 'package:isc/network/dio_helper.dart';
import '../../shared/Data.dart';
import 'package:xml/xml.dart' as xml;
import '../../shared/componants.dart';

//..............................................................................
String? SelectedContact;
class getDataCubit extends Cubit<getLoginDataStates> {
  List<Map<String, dynamic>> _users = [];
  int? userslength;
  String? selectedUser;
  String? selectedUserPassword;

  getDataCubit() : super(getLoginDataInitialState());

  static getDataCubit get(context) => BlocProvider.of(context);

  void getdata() async {
    try {
      emit(getLoginDataLoadingState());
      final response = await DioHelper.getData(url: 'http://192.168.1.88/api/users/');
      final data = response.data;
      _users = List<Map<String, dynamic>>.from(data);
      userslength = _users.length;

      emit(getLoginDataSucessState(_users));
    } catch (e) {
      emit(getLoginDataErrorState(e.toString()));
    }
  }

  void selectUser(String userName) {
    selectedUser = userName;
    selectedUserPassword = _users
        .firstWhere((user) => user['User_Name'] == userName)['User_Password'] as String?;
    doubleselectedUserID = _users
        .firstWhere((user) => user['User_Name'] == userName)['USER_ID'];
    ClinicID = _users
        .firstWhere((user) => user['User_Name'] == userName)['id_clinic'];
    Doctorname = _users
        .firstWhere((user) => user['User_Name'] == userName)['User_Name'];
    int? intid = doubleselectedUserID?.toInt();
    StringselectedUserID = intid?.toString();

    emit(getLoginDataSucessState(_users));
    print('$selectedUserPassword $StringselectedUserID $ClinicID $Doctorname');
  }

  void NewUser({
    required String? UerName,
    required String? Phone,
    required String? Address,
    required String? PSW,
    required String? Email,
    required String? mob,
    required int? ID,
  }) {
    emit(LoadingNewUser());

    DioHelper.postData(
      url: 'http://192.168.1.88/api/users/',
      data: {
        'USER_ID': ID ?? '',
        'User_Name': UerName ?? '',
        'User_login': UerName ?? '',
        'address': Address ?? '',
        'User_Password': PSW,
        'status': true,
        'create_date': '${DateTime.now()}',
        'id_clinic': ClinicID,
        'mob': mob,
        'email ': Email,
      },
    ).catchError((error) {
      print(error);
      emit(ErrorNewUser(error.toString()));
    });
    emit(SuccessNewUser());
  }

  bool validatePassword(String password) {
    if (selectedUserPassword == null) return false;
    return selectedUserPassword == password;
  }

  void submitForm(String password, BuildContext context) {
    if (selectedUser == null) {
      emit(getLoginDataErrorState('Please select a user.'));
    } else if (validatePassword(password)) {
      emit(getLoginDataSuccessMessage('Password is correct!'));
      // Navigate to BookingList
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      emit(getLoginDataErrorState('Password is incorrect!'));
    }
  }

  // Function to get the largest USER_ID
  double? getLargestUserId() {
    if (_users.isNotEmpty) {
      // Find the user with the largest USER_ID as double
      return _users.map((user) => user['USER_ID'] as double).reduce((a, b) => a > b ? a : b);
    }
    return null; // Return null if _users is empty
  }
}
//..............................................................................
class getDoctorDataCubit extends Cubit<getDoctorDataStatus> {
  getDoctorDataCubit() : super(getDoctorDataInitState());

  static getDoctorDataCubit get(context) => BlocProvider.of(context);
  List<dynamic> Doctors = [];

  String errormessage = '';

  getDoctorDataCubit.DoctorDataCubit() : super(getDoctorDataInitState());
  void NewDoctor({
    required String? UerName,
    required String? Insip_ID,
    required String? Address,
    required String? PSW,
    required String? Email,
    required String? mob,
    required int? ID,
  }) {
    emit(NewDoctorLoadingState());

    DioHelper.postData(
      url: 'http://192.168.1.88/api/Doctor',
      data: {
        'DOC': ID ?? '',
        'NAME': UerName ?? '',
        'user_name': Doctorname ?? '',
        'name_en': UerName ?? '',
        'insip_name': Insip_ID ?? '',
        'Mobile': mob ?? '',
        'psw': PSW,
        'id_clinic': ClinicID,
        'email': Email,
      },
    ).catchError((error) {
      emit(NewDoctorErrorState(error.toString()));
      print('Error:  ${error.toString()}');
    });
    emit(NewDoctorSucessState());
  }

  void getdata() async {
    String url =
        'http://192.168.1.88/api/secudleout/filtered/$ClinicID/';
    try {
      emit(getDoctorDataLoadingState());

      // Fetch data logic here
      final response = await DioHelper.getData(url: url);
      Doctors = response.data;
      reservationslenth = Doctors.length;
      emit(getDoctorDataSucessState(Doctors));
    } catch (e) {
      print('Error: ${e}');
      errormessage = 'Network Error';
      emit(getDoctorDataErrorState(e.toString()));
    }
  }
  void getDoctors() async {
    String url =
        'http://192.168.1.88/api/DOCTOR';
    try {
      emit(getDoctorDataLoadingState());

      // Fetch data logic here
      final response = await DioHelper.getData(url: url);
      Doctors = response.data;
      reservationslenth = Doctors.length;
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

  static getpatientDataCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Map<String, dynamic>? patients;
  Map<String, dynamic>? patients2;
  List<dynamic>? patientTable;
  String patientname2 = 'اكتب كود المريض';
  String errormessage = '';
  String? patientcode2 = '';
  int? patientlenth;

  void getdata() async {
    if (patientcode2 == null || patientcode2!.isEmpty) return;

    String url = 'http://192.168.1.88/api/Patient/filtered/$ClinicID/$patientcode2';

    try {
      emit(getpatientDataLoadingState());

      final response = await DioHelper.getData(url: url);
      if (response.data is List) {
        List<dynamic> patientList = response.data;
        if (patientList.isNotEmpty) {
          // Take the first element from the list
          patients = patientList[0] as Map<String, dynamic>?;
          patientname2 = patients?["NAME"] ?? 'Patient name';
          patientcode2 = patients?["PCODE"].toString() ?? '';
          emit(getpatientDataSucessState(patients!));
        } else {
          // No patient found for the given code
          patientname2 = 'Patient not found';
          emit(getpatientDataErrorState(errormessage));
        }
      } else {
        patientname2 = 'Unexpected data format';
        emit(getpatientDataErrorState(errormessage));
      }
    } catch (e) {
      patientname2 = 'Patient not existed ';
      emit(getpatientDataErrorState(errormessage));
      print(e);
    }
  }

  void getpatientsdata() async {
    String url = 'http://192.168.1.88/api/Patient/filtered/$ClinicID/';
    try {
      emit(getpatientDataLoadingState());
      final response = await DioHelper.getData(url: url);
      patientTable = response.data;
      if(patientTable == null )
        {
          patientlenth =1;
        }
      else{
        patientlenth = patientTable!.length + 1;
      }
      emit(getpatientTableSucessState(patientTable!.length));
    } catch (e) {
      errormessage = 'Network Error';
      print(e);

    }
  }

  void NewPatient({
    required String? PatientName,
    required String? NationalID,
    required String? Phone,
    required String? Address,
    required String? BirthDate,
    required int? code,
    required bool? Gender,
  }) {
    emit(getpatientDataLoadingState());

    DioHelper.postData(
      url: 'http://192.168.1.88/api/Patient/',
      data: {
        'NAME': PatientName ?? '',
        'id_NO': NationalID ?? '',
        'PHONE': Phone ?? '',
        'ADDRESS': Address ?? '',
        'BIRTH_DT': BirthDate,
        'mal': Gender ?? '',
        'PCODE': code,
        'id_clinic': ClinicID,
      },
    ).catchError((error) {
      print(error);
      emit(getpatientDataErrorState(error.toString()));
    });
    emit(newpatientSuccessState());
  }

  void updatePatientCode(String value) {
    patientcode2 = value;
    patientcode = patientcode2;
    getdata();
  }
}
//..............................................................................
class BookingCubit extends Cubit<Bookingtatus> {
  static BookingCubit get(BuildContext context) => BlocProvider.of(context);

  BookingCubit() : super(BookingInitState());

  bool _isOption1Selected = false;
  Map<String, dynamic>? _data;

  String url = 'http://192.168.1.88/api/secudleout/$selectedNo';

  void Deletbookoing() {
    print(url);
    DioHelper.DeleteData(
      url: url,
    );
  }

  void newBookin({
    required String? time,
    required String? contact,
    required String? name,
    required String? patcode,
    required String? DayType,
    required String? Contact,
    required bool? again,
    required int? id_clinic,

  }) {
    emit(BookingLoadingState());

    DioHelper.postData(
      url: 'http://192.168.1.88/api/SecudleOut/',
      data: {
        'OPERATOR': Doctorname ?? '',
        'op_code': StringselectedUserID ?? '',
        'SDATE': Date ?? '${DateTime.now()}',
        'PATIENT': name ?? '',
        'cconfirm': false,
        'oper_roomt': "${again == false ? 'كشف' : 'اعاده'}",
        'pat_code': patcode ?? '',
        'day_typ': DayType ?? '',
        'cont_name': Contact ?? 'Private',
        'pcode': reservationslenth + 1,
        'id_clinic':id_clinic??''
      },
    ).catchError((error) {

      print(error);
      emit(BookingErrorState(error.toString()));
    });
  }

  void toogel() {
    _isOption1Selected = !_isOption1Selected;
    emit(Bookingswitchstate(_isOption1Selected));
  }

  void edittoogel() {
    New = !New;
    emit(editBookingswitchstate(New));
  }

  void editBookin({
    required String? No,
    required String? time,
    required String? name,
    required String? patcode,
    required String? DayType,
    required String? Contact,
    required bool? again,
  }) {
    emit(BookingLoadingState());

    DioHelper.putData(
      url: 'http://192.168.1.88/api/SecudleOut/$selectedNo',
      data: {
        'no': No ?? '',
        'OPERATOR': Doctorname ?? '',
        'op_code': StringselectedUserID ?? '',
        'SDATE': Date ?? '',
        'PATIENT': name ?? '$patientname',
        'cconfirm': false,
        'oper_roomt': "${again == false ? 'كشف' : 'اعاده'}",
        'pat_code': patcode ?? '',
        'day_typ': DayType ?? '',
        'cont_name': Contact ?? '',
      },
    ).catchError((error) {
      print(error);
      emit(BookingErrorState(error.toString()));
    });
  }

  String convertDateFormat(String inputDateString) {
    try {
      final inputDateTime = DateTime.parse(inputDateString);
      final outputFormat = DateFormat('yyyy/MM/dd h:mm a');
      return outputFormat.format(inputDateTime);
    } catch (e) {
      // Handle potential parsing errors
      print('Error parsing date: $e');
      return 'Invalid date format'; // Or return a default value
    }
  }

  void getBookindata() async {
    try {
      emit(BookingLoadingState());
      final response = await DioHelper.getData(url: url);
      _data = response.data;
      emit(BookingSucessState());
      patientcode = '${_data?['pat_code']}';
      patientname = '${_data?['PATIENT']}';
      Date = '${_data?['SDATE']}';
      Contact = '${_data?['cont_name']}';
      New = _data?['oper_roomt'] == 'اعاده';

      initialDate2 = DateTime.parse(Date!);
      Date = convertDateFormat(Date!);
      emit(BookingaddedState());
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
      final response = await DioHelper.getData(
          url: 'http://192.168.1.88/api/Contact/filtered');
      final data = response.data as List<dynamic>;
      Contacts =
          data.map<String>((contact) => contact['NAME'] as String).toList();
      emit(getContactDataSucessState(Contacts));
    } catch (e) {
      emit(getContactDataErrorState(e.toString()));
    }
  }

  void selectUser(String contact) {
    SelectedContact = contact;
    Contact = SelectedContact;
    emit(getContactDataSucessState(Contacts));
  }
}
//..............................................................................
class SelectDateCubit extends Cubit<SelectDateState> {
  DateTime? selectedDate;

  SelectDateCubit()
      : super(SelectDateInitialState(
            DateTime.now())); // Initialize with today's date

  void selectDate(DateTime date) {
    selectedDate = date;
    emit(SelectDateChangedState(date));
  }

  void clearDate() {
    selectedDate = DateTime.now(); // Reset to today's date
    emit(SelectDateChangedState(
        selectedDate!)); // Emit updated state with today's date
  }
}
//..............................................................................
class AnimationCubit extends Cubit<AnimationState> {
  AnimationCubit() : super(AnimationInitialState());

  void selectAddAnimation() {
    isExpanded = !isExpanded;
    iscollabsed = false;
    emit(AnimationExpandedState());
  }

  void selectAdd2Animation() {
    iscollabsed = !iscollabsed;
    emit(AnimationCollapsed2State());
  }

  void resetAnimation() {
    isExpanded = !isExpanded;
    emit(AnimationInitialState());
  }
}
//..............................................................................
class ChoiceChipCubit extends Cubit<ChoiceChipState> {
  ChoiceChipCubit() : super(ChoiceChipInitial());

  void changeChoice(String newChoice) {
    emit(ChoiceChipSelected(newChoice));
  }

  // Optional: You can add methods like resetChoice if needed
  void resetChoice() {
    emit(ChoiceChipInitial());
  }
}

//..............................................................................
//..............................................................................
//..............................................................................
//..............................................................................
class MedsCubit extends Cubit<MedsState> {
  MedsCubit() : super(MedsState.initial());

  static final MedsCubit instance = MedsCubit();

  Future<void> NewPrescription({
    required String? PatientName,
    required String? patcode,
    required String? Drugname,
    required String? Docno,
    required String? use_nam_ar,
    required String? qty,
  }) async {
    try {
      await DioHelper.postData(
        url: 'http://192.168.1.88/api/medRec2',
        data: {
          'use_nam_ar':use_nam_ar,
          'qty':qty,
          'pat_name': PatientName ?? '',
          'code': patcode ?? '',
          'drug_name': Drugname ?? '',
          'doc_no': Docno ?? '',
          'doc_date': '${DateTime.now()} ' ?? '',
          'id_clinic': ClinicID ?? '',
        },
      );
      emit(MedsState.initial());
    } catch (error) {
      print(error);
    }
  }

  // Ensure all lists are initialized empty
  @override
  MedsState get initialState => MedsState.initial();

  // Method to add a new medication
  void addMed() {
    final currentState = state;

    // Check if we have at least one controller (if the list is empty, we allow adding the first item)
    if (currentState.controllers.isNotEmpty) {
      final lastIndex = currentState.controllers.length - 1;

      final medNameController = currentState.controllers[lastIndex];
      final newMedicationName = medNameController.text;

      // Check if the medication name field is empty
      if (newMedicationName.isEmpty) {
        emit(currentState.copyWith(error: 'Medication name cannot be empty'));
        return;
      }

      // Check for duplicate medications
      final isDuplicate = currentState.medications.any((med) => med['name'] == newMedicationName);
      if (isDuplicate) {
        emit(currentState.copyWith(error: 'Medication is duplicated'));
        return;
      }

      // Add the medication to the list
      final updatedMedications = List<Map<String, String>>.from(currentState.medications)
        ..add({'name': newMedicationName});

      emit(currentState.copyWith(
        medications: updatedMedications,
        error: null,
      ));
    }

    // Add new controllers for name, times per day, and days
    final updatedControllers = List<TextEditingController>.from(currentState.controllers)
      ..add(TextEditingController());
    final updatedTimesPerDayControllers = List<TextEditingController>.from(currentState.timesPerDayControllers)
      ..add(TextEditingController());
    final updatedDaysControllers = List<TextEditingController>.from(currentState.daysControllers)
      ..add(TextEditingController());

    // Emit updated state with new controllers
    emit(currentState.copyWith(
      controllers: updatedControllers,
      timesPerDayControllers: updatedTimesPerDayControllers,
      daysControllers: updatedDaysControllers,
      error: null,
    ));
  }

  // Method to delete a medication
  void deleteMed(int index) {
    final currentState = state;
    // Ensure the index is valid and remove the item
    if (index >= 0 && index < currentState.controllers.length) {
      final updatedMedications = List<Map<String, String>>.from(currentState.medications);
      if (index < updatedMedications.length) {
        updatedMedications.removeAt(index);
      }

      // Update the controllers and medication lists
      final updatedControllers = List<TextEditingController>.from(currentState.controllers)
        ..removeAt(index);
      final updatedTimesPerDayControllers = List<TextEditingController>.from(currentState.timesPerDayControllers)
        ..removeAt(index);
      final updatedDaysControllers = List<TextEditingController>.from(currentState.daysControllers)
        ..removeAt(index);

      // Emit updated state
      emit(currentState.copyWith(
        controllers: updatedControllers,
        timesPerDayControllers: updatedTimesPerDayControllers,
        daysControllers: updatedDaysControllers,
        medications: updatedMedications,
        error: null,
      ));
    }
  }

  // Get list of medications with details (name, times per day, days)
  List<Map<String, String>> getMedications() {
    final medications = <Map<String, String>>[];

    for (int i = 0; i < state.controllers.length; i++) {
      if (i < state.timesPerDayControllers.length && i < state.daysControllers.length) {
        final name = state.controllers[i].text;
        final timesPerDay = state.timesPerDayControllers[i].text;
        final days = state.daysControllers[i].text;

        if (name.isNotEmpty && timesPerDay.isNotEmpty && days.isNotEmpty) {
          medications.add({
            'name': name,
            'timesPerDay': timesPerDay,
            'days': days,
          });
        }
      }
    }

    return medications;
  }
}
//..............................................................................
class RecordssCubit extends Cubit<RecordsState> {
  RecordssCubit()
      : super(RecordsState(
          controllers: [TextEditingController()],

    Records: [],
          error: null,
        ));

  void addRecords() {
    final currentState = state;
    final lastIndex = currentState.controllers.length - 1;

    if (lastIndex < 0) {
      emit(currentState.copyWith(
          error: 'No controllers available to add Records'));
      return;
    }

    final medNameController = currentState.controllers[lastIndex];
    final newRecordsicationName = medNameController.text;

    if (newRecordsicationName.isEmpty) {
      emit(currentState.copyWith(error: 'Examination name cannot be empty'));
      return;
    }

    final isDuplicate = currentState.Records
        .any((REC) => REC['name'] == newRecordsicationName);

    if (isDuplicate) {
      emit(currentState.copyWith(error: 'Examination is duplicated'));
      return;
    }

    final updatedRecordsications =
    List<Map<String, String>>.from(currentState.Records)
      ..add({'name': newRecordsicationName});

    final updatedControllers =
    List<TextEditingController>.from(currentState.controllers)
      ..add(TextEditingController());


    emit(currentState.copyWith(
      controllers: updatedControllers,
      Records: updatedRecordsications,
      error: null,
    ));
  }

  List<Map<String, String>> getRecordsications() {
    final Records = <Map<String, String>>[];

    for (int i = 0; i < state.controllers.length; i++) {
      // Check bounds for all lists before accessing
      if (i < state.controllers.length) {
        final name = state.controllers[i].text;


        if (name.isNotEmpty ) {
          Records.add({
            'name': name,

          });
        }
      } else {
        print('Index out of bounds in getRecordsications: i=$i');
      }
    }

    return Records;
  }
}
//..............................................................................
class ServicessCubit extends Cubit<ServicesState> {
  ServicessCubit() : super(ServicesState(controllers: [TextEditingController()],
    Services: [], error: null,));
  void addServices() {
    final currentState = state;
    final lastIndex = currentState.controllers.length - 1;
    if (lastIndex < 0) {
      emit(currentState.copyWith(
          error: 'No controllers available to add Services'));
      return;
    }

    final medNameController = currentState.controllers[lastIndex];
    final newServicesicationName = medNameController.text;

    if (newServicesicationName.isEmpty) {
      emit(currentState.copyWith(error: 'Service name cannot be empty'));
      return;
    }

    final isDuplicate = currentState.Services
        .any((REC) => REC['name'] == newServicesicationName);

    if (isDuplicate) {
      emit(currentState.copyWith(error: 'Service is duplicated'));
      return;
    }

    final updatedServicesications =
    List<Map<String, String>>.from(currentState.Services)
      ..add({'name': newServicesicationName});

    final updatedControllers =
    List<TextEditingController>.from(currentState.controllers)
      ..add(TextEditingController());


    emit(currentState.copyWith(
      controllers: updatedControllers,
      Services: updatedServicesications,
      error: null,
    ));
  }

  List<Map<String, String>> getServices() {
    final Services = <Map<String, String>>[];

    for (int i = 0; i < state.controllers.length; i++) {
      // Check bounds for all lists before accessing
      if (i < state.controllers.length) {
        final name = state.controllers[i].text;
        if (name.isNotEmpty ) {
          Services.add({
            'name': name,
          });
        }
      } else {
        print('Index out of bounds in getServices: i=$i');
      }
    }

    return Services;
  }
}
//..............................................................................

class getDrugsDataCubit extends Cubit<getDrugsDataStatus> {
  List<Map<String, dynamic>> Drugs = [];
  List<Map<String, dynamic>> Examinations = [];
  String? selectedDrug;
  String? selectedDrugCode;
  List<Map<String, dynamic>> departments = [];
  String? selectedDepartment;
  int? selectedDepartmentCategory;

  getDrugsDataCubit() : super(getDrugsDataInitState());

  static getDrugsDataCubit get(context) => BlocProvider.of(context);

  void getDrugsdata() async {
    try {
      emit(getDrugsDataLoadingState());
      final response = await DioHelper.getData(
          url: 'http://192.168.1.88/api/drugClinic/filtered/$ClinicID');
      final data = response.data;

      if (data is List) {
        Drugs = data.map((item) => Map<String, dynamic>.from(item)).toList();
        print('Drugs loaded: $Drugs'); // Debug print
        emit(getDrugsDataSucessState(Drugs));
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      print(e);
      emit(getDrugsDataErrorState(e.toString()));
    }
  }

  void getExaminationdata() async {
    try {
      emit(getDrugsDataLoadingState());
      final response = await DioHelper.getData(
          url: 'http://192.168.1.88/api/hosDept/filtered/$ClinicID');
      final data = response.data;

      if (data is List) {
        Examinations = data.map((item) => Map<String, dynamic>.from(item)).toList();
        print('Examinations loaded: $Examinations'); // Debug print
        emit(getDrugsDataSucessState(Drugs));
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      print(e);
      emit(getDrugsDataErrorState(e.toString()));
    }
  }

  void getDepartmentsData() async {
    try {
      emit(getDepartmentsDataLoadingState());
      final response = await DioHelper.getData(
          url: 'http://192.168.1.88/api/hosDept/filtered/2');
      final data = response.data;
      print(data);

      if (data is List) {
        departments = data.map((item) => Map<String, dynamic>.from(item)).toList();
        print('Departments loaded: $departments'); // Debug print
        emit(getDepartmentsDataSuccessState(departments));
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      print(e);
      emit(getDepartmentsDataErrorState(e.toString()));
    }
  }

  void selectDepartment(String departmentName) {
    selectedDepartment = departmentName;
    selectedDepartmentCategory = departments.firstWhere(
          (dept) => dept['NAME'] == departmentName,
      orElse: () => {'CATEGORY': null},
    )['CATEGORY'] as int?;

    emit(getDepartmentsDataSuccessState(departments));
  }

  void selectUser(String drug) {
    selectedDrug = drug;
    selectedDrugCode = Drugs.firstWhere(
          (item) => item['E_DESC'] == drug,
      orElse: () => {'noo': null},
    )['noo'].toString();

    emit(getDrugsDataSucessState(Drugs));
  }
}
class DrugClinicCubit extends Cubit<DrugClinicState> {
  final Dio _dio;
  DrugClinicCubit(this._dio) : super(DrugClinicInitialState());

  Future<void> fetchDrugClinicData() async {
    emit(DrugClinicLoadingState());
    try {
      final response = await _dio.get('http://192.168.1.88/api/drugClinic/filtered/$ClinicID');

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

//..............................................................................



//..............................................................................
class HospitalDepartment {
  final int category;
  final String name;
  final String nameEnglish;
  final String? remark;
  final int idClinic;

  HospitalDepartment({
    required this.category,
    required this.name,
    required this.nameEnglish,
    this.remark,
    required this.idClinic,
  });

  factory HospitalDepartment.fromJson(Map<String, dynamic> json) {
    return HospitalDepartment(
      category: json['CATEGORY'] ?? 0,
      name: json['NAME'] ?? '',
      nameEnglish: json['name_e'] ?? '',
      remark: json['remark'],
      idClinic: json['id_clinic'] ?? 0,
    );
  }
}

class HospitalDepartmentCubit extends Cubit<HospitalDepartmentState> {
  final Dio dio;

  List<HospitalDepartment>? departments;

  HospitalDepartmentCubit(this.dio) : super(HospitalDepartmentInitialState());

  Future<void> fetchHospitalDepartments() async {
    emit(HospitalDepartmentLoadingState());
    try {
      final response = await dio.get('http://192.168.1.88/api/hosDept/filtered/');
      departments = (response.data as List).map((dept) => HospitalDepartment.fromJson(dept)).toList();
      emit(HospitalDepartmentLoadedState(departments!));
    } catch (error) {
      emit(HospitalDepartmentErrorState(error.toString()));
    }
  }
  void NewHospitalDepartment({
    required String? NAME,
    required String? remark,

  }) {
    DioHelper.postData(
      url: 'http://192.168.1.88/api/hosDept/',
      data: {
        'NAME': NAME ?? '',
        'remark': remark ?? '',
        'id_clinic': ClinicID ?? '',

      },
    ).catchError((error) {
      print(error);
      emit(HospitalDepartmentErrorState(error.toString()));
    });
    emit(HospitalDepartmentSuccessState());
  }
}


//..............................................................................
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

// Add any methods or business logic here if needed
}
//..............................................................................
class DateCodePair {
  final String date; // Original date field (description)
  final String code; // Code field from the API
  final String docno; // Document number
  final String docDate; // Document date from medrec2 API
  final String patName; // Patient name, optional field

  DateCodePair({
    required this.date,
    required this.code,
    required this.docno,
    required this.docDate, // Required doc_date
    this.patName = 'Unknown Patient', // Default value if not provided
  });
}
class GroupedDateCodePair {
  final String docno; // Group by docno
  final List<DateCodePair> dateCodePairs;

  GroupedDateCodePair({
    required this.docno,
    required this.dateCodePairs,
  });
}
class CombinedDateCubit2 extends Cubit<CombinedDateState2> {
  List<DateCodePair> allDateCodePairs = [];
  String filterCode = '';

  CombinedDateCubit2() : super(CombinedDateInitial2());

  static CombinedDateCubit2 get(BuildContext context) =>
      BlocProvider.of<CombinedDateCubit2>(context);

  // Function to fetch and extract date, code, docno, docDate, and patName (if available)
  Future<List<DateCodePair>> _fetchAndExtractDateCodePairs(
      String url,
      String Function(Map<String, dynamic>) dateExtractor,
      String Function(Map<String, dynamic>) codeExtractor,
      String Function(Map<String, dynamic>) docnoExtractor,
      {String Function(Map<String, dynamic>)? patNameExtractor,
      String Function(Map<String, dynamic>)? docDateExtractor}) async {
    try {
      final response = await DioHelper.getData(url: url);
      final dataList = response.data as List<dynamic>? ?? [];

      final dateCodePairs = dataList.map((item) {
        final map = item as Map<String, dynamic>;

        return DateCodePair(
          date: dateExtractor(map),
          code: codeExtractor(map),
          docno: docnoExtractor(map),
          docDate:
              docDateExtractor != null ? docDateExtractor(map) : 'Unknown Date',
          patName: patNameExtractor != null
              ? patNameExtractor(map)
              : 'Unknown Patient',
        );
      }).toList();

      return dateCodePairs;
    } catch (e) {
      emit(CombinedDateError2(e.toString()));
      return [];
    }
  }

  Future<void> getAllDateCodePairs() async {
    try {
      emit(CombinedDateLoadingState2());

      // Fetching data from different APIs
      final prescriptionsDateCodePairs = await _fetchAndExtractDateCodePairs(
        'http://192.168.1.88/api/medrec2/',
        (item) => (isArabicsaved?'دواء:  : ${item['drug_name']}':'Drugs : ${item['drug_name']}') ?? 'Unknown Date',
        (item) => item['code'].toString() ?? 'Unknown Code',
        (item) => item['doc_no'].toString() ?? 'Unknown Doc No',
        docDateExtractor: (item) => item['doc_date'] ?? 'Unknown Date',
        patNameExtractor: (item) => item['pat_name'] ?? 'Unknown Patient', // Extracting pat_name
      );

      final recordsDateCodePairs = await _fetchAndExtractDateCodePairs(
        'http://192.168.1.88/api/medrec1/',
        (item) => (isArabicsaved?'شكوي :${item['sub_comp_name']}':'Complain : ${item['sub_comp_name']}') ?? 'Unknown Date',
        (item) => item['CODE'].toString() ?? 'Unknown Code',
        (item) => item['DOC_NO'].toString() ?? 'Unknown Doc No',
        docDateExtractor: (item) => item['doc_date'] ?? 'Unknown Date',
        patNameExtractor: (item) => item['pat_name'] ?? 'Unknown Patient',
      );

      final servicesDateCodePairs = await _fetchAndExtractDateCodePairs(
        'http://192.168.1.88/api/medrec3/',
        (item) => (isArabicsaved?'خدمه : ${item['ser_name']}':'Service : ${item['ser_name']}') ?? 'Unknown Date',
        (item) => item['code'].toString() ?? 'Unknown Code',
        (item) => item['doc_no'].toString() ?? 'Unknown Doc No',
        docDateExtractor: (item) => item['doc_date'] ?? 'Unknown Date',
        patNameExtractor: (item) => item['pat_name'] ?? 'Unknown Patient',
      );

      final medrec4DateCodePairs = await _fetchAndExtractDateCodePairs(
        'http://192.168.1.88/api/medrec4/',
        (item) => (isArabicsaved?'تشخيص: ${item['dis_name']}':'Examination : ${item['dis_name']}') ?? 'Unknown Date',
        (item) => item['code'].toString() ?? 'Unknown Code',
        (item) => item['doc_no'].toString() ?? 'Unknown Doc No',
        docDateExtractor: (item) => item['doc_date'] ?? 'Unknown Date',
        patNameExtractor: (item) => item['pat_name'] ?? 'Unknown Patient',
      );

      final surgerysDateCodePairs = await _fetchAndExtractDateCodePairs(
        'http://192.168.1.88/api/medSurgey/',
        (item) => (isArabicsaved?'جراحه: ${item['sur_nam_e']}':'Surgery : ${item['sur_nam_e']}') ?? 'Unknown Date',
        (item) => item['pcode'].toString() ?? 'Unknown Code',
        (item) => item['doc_no'].toString() ?? 'Unknown Doc No',
        docDateExtractor: (item) => item['doc_date'] ?? 'Unknown Date',
        patNameExtractor: (item) => item['pat_name'] ?? 'Unknown Patient',
      );

      // Combine all the fetched data
      allDateCodePairs = [
        ...medrec4DateCodePairs,
        ...prescriptionsDateCodePairs,
        ...recordsDateCodePairs,
        ...servicesDateCodePairs,
        ...surgerysDateCodePairs,
      ];

      _filterAndGroupDataByDocNo();
      printMaxDocNo();
    } catch (e) {
      emit(CombinedDateError2(e.toString()));
    }
  }

  void printMaxDocNo() {
    if (allDateCodePairs.isEmpty) {
      print('No data available');
      return;
    }
    final maxDocNoPair = allDateCodePairs.reduce((a, b) {
      final docNoA = int.tryParse(a.docno) ?? 0;
      final docNoB = int.tryParse(b.docno) ?? 0;

      return docNoA > docNoB ? a : b;
    });
    docslenth = int.parse(maxDocNoPair.docno)+1;
    print('Maximum Doc No: $docslenth');
  }

  void updatePatientCode(String code) {
    filterCode = code;
    _filterAndGroupDataByDocNo();
  }

  // Filter and group data by doc_no
  void _filterAndGroupDataByDocNo() {
    var filteredList = allDateCodePairs.where((pair) {
      if (filterCode.isEmpty) return true;
      return pair.code == filterCode;
    }).toList();

    final groupedDateCodePairs = _groupByDocNo(filteredList);

    emit(CombinedDateLoaded2(groupedDateCodePairs));
  }

  // Group data by docno
  List<GroupedDateCodePair> _groupByDocNo(List<DateCodePair> pairs) {
    final Map<String, List<DateCodePair>> groupedMap = {};

    for (var pair in pairs) {
      if (groupedMap.containsKey(pair.docno)) {
        groupedMap[pair.docno]!.add(pair);
      } else {
        groupedMap[pair.docno] = [pair];
      }
    }

    // Convert map to a list of GroupedDateCodePair and sort by docno in descending order
    final groupedList = groupedMap.entries.map((entry) {
      return GroupedDateCodePair(
        docno: entry.key,
        dateCodePairs: entry.value,
      );
    }).toList();

    // Sort the list in reverse order based on the docno
    groupedList.sort((a, b) => int.parse(b.docno).compareTo(int.parse(a.docno)));

    return groupedList;
  }
}
//..............................................................................
class GetExaminationDateCubit extends Cubit<GetExaminationDataStatus> {
  List<dynamic> allExaminations = [];
  Map<String, List<dynamic>> groupedExaminations = {};
  String filterCode = '';
  String url = 'http://192.168.1.88/api/medRec4/';
  GetExaminationDateCubit() : super(GetExaminationDataInitState());
  static GetExaminationDateCubit get(context) => BlocProvider.of(context);
  void getdata() async {
    try {
      emit(GetExaminationDataLoadingState());
      final response = await DioHelper.getData(url: url);
      allExaminations = response.data;

      _filterAndGroupData();

      emit(GetExaminationDataSuccessState(groupedExaminations));
    } catch (e) {
      print('Error: $e');
      emit(GetExaminationDataErrorState(e.toString()));
    }
  }
  void updatePatientCode(String code) {
    filterCode = code;
    _filterAndGroupData();
    emit(GetExaminationDataSuccessState(groupedExaminations));
  }
  Future<void> NewRecord({
    required String? PatientName,
    required String? patcode,
    required String? disname,
    required String? Docno,
  }) async {
    try {
      emit(GetExaminationDataLoadingState()); // Emit loading state

      await DioHelper.postData(
        url: url,
        data: {
          'doc_date': '${DateTime.now()} ' ?? '',
          'id_clinic':1,
          'pat_name': PatientName ?? '',
          'code': patcode ?? '',
          'dis_name': disname ?? '',
          'doc_no': Docno ?? '',
          'id_clinic': ClinicID ?? '',
        },
      );

      // Emit success state after successful data posting
      emit(GetExaminationDataSuccessState({}));
    } catch (error) {
      print(error);
      emit(GetExaminationDataErrorState(error.toString()));
    }
  }
  Future<void> Newimage({
    required File? Image,
  }) async {
    try {
      emit(GetExaminationDataLoadingState()); // Emit loading state

      await DioHelper.postData(
        url: ('http://192.168.1.88/api/medRec1'),
        data: {
          'pict1': Image ?? '',

        },
      );

      // Emit success state after successful data posting
      emit(GetExaminationDataSuccessState({}));
    } catch (error) {
      print(error);
      emit(GetExaminationDataErrorState(error.toString()));
    }
  }
  void _filterAndGroupData() {
    var filteredList = allExaminations.where((item) {
      if (filterCode.isEmpty) return true;
      return item['code'].toString() == filterCode;
    }).toList();

    // Group filtered examinations by doc_no
    groupedExaminations = {};
    for (var item in filteredList) {
      String docno = item['doc_no'].toString() ?? 'Unknown DocNo';

      if (!groupedExaminations.containsKey(docno)) {
        groupedExaminations[docno] = [];
      }
      groupedExaminations[docno]!.add(item);
    }

    // Sort the grouped examinations by doc_no in descending order
    groupedExaminations = Map.fromEntries(
        groupedExaminations.entries.toList()
          ..sort((a, b) => int.parse(b.key).compareTo(int.parse(a.key)))
    );
  }
}
class GetservicesDateCubit extends Cubit<GetServiceDataStatus> {
  List<dynamic> allServices = [];
  Map<String, List<dynamic>> groupedServices = {};
  String filterCode = '';
  String url = 'http://192.168.1.88/api/medRec3/';

  GetservicesDateCubit() : super(GetServiceDataInitState());

  static GetservicesDateCubit get(context) => BlocProvider.of(context);

  // Method to fetch data
  void getData() async {
    try {
      emit(GetServiceDataLoadingState());
      final response = await DioHelper.getData(url: url);
      allServices = response.data;

      // Filter and group the data
      _filterAndGroupData();

      emit(GetServiceDataSuccessState(groupedServices));
    } catch (e) {
      print('Error: $e');
      emit(GetServiceDataErrorState(e.toString()));
    }
  }

  // Method to post new service data
  Future<void> NewService({
    required String? PatientName,
    required String? patcode,
    required String? disname,
    required String? Docno,
  }) async {
    try {
      emit(GetServiceDataLoadingState()); // Emit loading state

      await DioHelper.postData(
        url: url,
        data: {
          'doc_date': DateNow,
          'pat_name': PatientName ?? '',
          'code': patcode ?? '',
          'ser_name': disname ?? '',
          'doc_no': Docno ?? '',
          'id_clinic': ClinicID ?? '',
          'ser_no': 0
        },
      );

      // Emit success state after successful data posting
      emit(GetServiceDataSuccessState({}));
    } catch (error) {
      print(error);
      emit(GetServiceDataErrorState(error.toString()));
    }
  }

  // Update the patient code and refresh data
  void updatePatientCode(String code) {
    filterCode = code;
    _filterAndGroupData();
    emit(GetServiceDataSuccessState(groupedServices));
  }

  // Method to filter and group the data
  void _filterAndGroupData() {
    // Filter the services based on the patient code
    var filteredList = allServices.where((item) {
      if (filterCode.isEmpty) return true;
      return item['code'].toString() == filterCode;
    }).toList();

    // Group filtered services by `doc_no`
    groupedServices = {};
    for (var item in filteredList) {
      String docno = item['doc_no'].toString() ?? 'Unknown DocNo';

      if (!groupedServices.containsKey(docno)) {
        groupedServices[docno] = [];
      }
      groupedServices[docno]!.add(item);
    }

    // Sort the groups by `doc_no` in descending order
    groupedServices = Map.fromEntries(
        groupedServices.entries.toList()
          ..sort((a, b) => int.parse(b.key).compareTo(int.parse(a.key)))
    );
  }
}
class GetPrescreptionDateCubit extends Cubit<GetPrescreptionDataStatus> {
  List<dynamic> allPrescriptions = [];
  Map<String, List<dynamic>> groupedPrescriptions = {};
  String filterCode = '';

  GetPrescreptionDateCubit() : super(GetPrescreptionDataInitState());

  static GetPrescreptionDateCubit get(context) => BlocProvider.of(context);

  void getdata() async {
    String url = 'http://192.168.1.88/api/medRec2/';
    try {
      emit(GetPrescreptionDataLoadingState());
      final response = await DioHelper.getData(url: url);
      allPrescriptions = response.data;
      print('.........................................................\n'
          '...................$docslenth...............................\n'
          '.............................................................');
      _filterAndGroupData();

      emit(GetPrescreptionDataSucessState(groupedPrescriptions));
    } catch (e) {
      print('Error: $e');
      emit(GetPrescreptionDataErrorState(e.toString()));
    }
  }

  Future<void> NewPrescreption({
    required String? PatientName,
    required String? patcode,
    required String? Drugname,
    required String? Docno,
    required String? use_nam_ar,
    required String? qty,
  }) async {
    try {
      emit(GetPrescreptionDataLoadingState()); // Emit loading state

      await DioHelper.postData(
        url: 'http://192.168.1.88/api/medRec2',
        data: {
          'pat_name': PatientName ?? '',
          'code': patcode ?? '',
          'drug_name': Drugname ?? '',
          'doc_no': Docno ?? '',
          'doc_date': '${DateTime.now()} ' ?? '',
          'id_clinic': ClinicID ?? '',
          'use_nam_ar': use_nam_ar ?? '',
          'qty': qty ?? '',
        },
      );

      // Emit success state after successful data posting
      emit(GetPrescreptionDataSucessState({}));
    } catch (error) {
      print(error);
      emit(GetPrescreptionDataErrorState(error.toString()));
    }
  }

  void updatePatientCode(String code) {
    filterCode = code;
    _filterAndGroupData();
    emit(GetPrescreptionDataSucessState(groupedPrescriptions));
  }

  void _filterAndGroupData() {
    var filteredList = allPrescriptions.where((item) {
      if (filterCode.isEmpty) return true;
      return item['code'].toString() == filterCode;
    }).toList();

    // Group filtered prescriptions by docno
    groupedPrescriptions = {};
    for (var item in filteredList) {
      String docno = item['doc_no'].toString() ?? 'Unknown DocNo';

      if (!groupedPrescriptions.containsKey(docno)) {
        groupedPrescriptions[docno] = [];
      }
      groupedPrescriptions[docno]!.add(item);
    }

    // Sort the grouped prescriptions by docno in descending order
    groupedPrescriptions = Map.fromEntries(
        groupedPrescriptions.entries.toList()
          ..sort((a, b) => int.parse(b.key).compareTo(int.parse(a.key)))
    );
  }
}
//..............................................................................
class ShowPasswordcubit extends Cubit<ShowPasswordStatus> {
  ShowPasswordcubit() : super(HidePasswordState());
bool ShowPasswordbool =false ;

void ShowPassword()
  {
    ShowPasswordbool = !ShowPasswordbool;
    if(ShowPasswordbool) {
      emit(ShowPasswordState());
    }else
    {
      emit(HidePasswordState());
    }
  }
  void HidePassword()
  {
    ShowPasswordbool = false;
    emit(HidePasswordState());
  }

}
class GetimageDateCubit extends Cubit<GetExaminationDataStatus> {
  List<dynamic> allimages = [];
  Map<String, List<dynamic>> groupedimages = {};
  String filterCode = '';
  String url = 'http://192.168.1.88/api/medRec1/';
  GetimageDateCubit() : super(GetExaminationDataInitState());
  static GetExaminationDateCubit get(context) => BlocProvider.of(context);
  void getdata() async {
    try {
      emit(GetExaminationDataLoadingState());
      final response = await DioHelper.getData(url: url);
      allimages = response.data;


      emit(GetExaminationDataSuccessState(groupedimages));
    } catch (e) {
      print('Error: $e');
      emit(GetExaminationDataErrorState(e.toString()));
    }
  }

}
