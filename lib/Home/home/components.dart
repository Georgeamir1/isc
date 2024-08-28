
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isc/Home/home/prescription.dart';
const Color primary = Color(0xffA4D7FF);

// List<Widget> containers = [];
String? blodtype;
bool ischecked = false;
String? status;
DateTime date = DateTime.now();
String? gender;
bool showContainer = false;
bool Thyroid = false;
bool Gastrointestinal = false;
bool Asthma = false;
bool Diabetes = false;
bool Hypertension = false;
bool Cardiology = false;
var email=TextEditingController();
var FullName=TextEditingController();
var password=TextEditingController();
var confirmPassword=TextEditingController();
var nationalId=TextEditingController();
var phoneNumber=TextEditingController();
var emergencyNumber=TextEditingController();
var namecont= TextEditingController();
var des= TextEditingController();
var Report= TextEditingController();
var id= TextEditingController();
var treatment_name= TextEditingController();
var freq= TextEditingController();
var duration= TextEditingController();
String emaill ="";
int age(DateTime birthDate, date) {
  final now = DateTime.now();
  int age = now.year - birthDate.year;

  if (now.month < birthDate.month) {
    age--;
  } else if (now.month == birthDate.month && now.day < birthDate.day) {
    age--;
  }

  return age;
}


bool A1 = false;
bool A0 = false;
bool B1 = false;
bool B0 = false;
bool AB1 = false;
bool AB0 = false;
bool O1 = false;
bool O0 = false;

var patientcontainers =patient.length ;
var faimilycontainers = faimily.length;
var medicalHcontainers = medicalH.length;
var  treatmentcountainers= treatments.length;
var  prescriptioncountainers= prescription.length;
var labscontainers = labs.length;
bool doctor = false;

List patient =
[
];
List treatments =[
];
List prescription =[
];
List<File> imagelabs =[
];
List labs =[
];
List medicalH =[
];
List faimily =[
];

class ToggleButton extends StatelessWidget {
  final String buttonText;
  final bool isSelected;
  final VoidCallback onPressed;

  const ToggleButton({
    Key? key,
    required this.buttonText,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
    Expanded(
    child: Padding(
    padding: const EdgeInsets
        .symmetric(horizontal: 8.0),
    child: ElevatedButton(

          style: ButtonStyle(

            backgroundColor: isSelected
                ? MaterialStateProperty.all(Colors.red)
                : MaterialStateProperty.all(Colors.lightGreen),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    )]);
  }
}
void navigateToPage(BuildContext context, Widget destinationPage) {
  assert(destinationPage != null); // Ensure destinationPage is not null
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => destinationPage,
    ),
  );
}
class avatarbutton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return ElevatedButton(

     style: ElevatedButton.styleFrom( backgroundColor: Colors.white, elevation: 0,  shape: CircleBorder()),
     onPressed: () {
     navigateToPage(context, prescreption());
   }, child: Image.asset(
     "assets/images/Vector1.png",width: 120,

   ),
    );
  }

}

Future<Doctor> fetchDoctorData() async {
  final response = await http.get(Uri.parse('YOUR_API_URL_HERE'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return Doctor.fromJson(data);
  } else {
    throw Exception('Failed to load data');
  }
}
class Doctor {
  final int doc;
  final String name;
  final int insipId;
  final int gradeId;
  final int accCode;
  final String phoneHome1;
  final String phoneHome2;
  final String phoneClinic1;
  final String phoneClinic2;
  final String addClinic1;
  final String addClinic2;
  final String timeClinic1;
  final String timeClinic2;
  final String mobile;
  final String addHome;
  final String email;
  final String remarks;
  final double price1;
  final double price2;
  final double price3;
  final double curBal;
  final double opBal;
  final String nameEn;
  final String medRemark;
  final int serPart;
  final double serPct;
  final bool rad;
  final String signTitle;
  final int rate;
  final double value;
  final String psw;
  final String accBank;
  final String gradName;
  final double beg2;
  final String bal2;
  final String userName;
  final int cUser;
  final String insipName;
  final String enName;
  final int noOutPatn;
  final bool oc;
  final String tax1;
  final String tax2;
  final String tax3;
  final bool timeShare;
  final bool floor;
  final String cur;
  final String taxAc;
  final String emer;
  final int accCode2;
  final bool suspen;
  final bool suspend;
  final String pict;

  Doctor({
    required this.doc,
    required this.name,
    required this.insipId,
    required this.gradeId,
    required this.accCode,
    required this.phoneHome1,
    required this.phoneHome2,
    required this.phoneClinic1,
    required this.phoneClinic2,
    required this.addClinic1,
    required this.addClinic2,
    required this.timeClinic1,
    required this.timeClinic2,
    required this.mobile,
    required this.addHome,
    required this.email,
    required this.remarks,
    required this.price1,
    required this.price2,
    required this.price3,
    required this.curBal,
    required this.opBal,
    required this.nameEn,
    required this.medRemark,
    required this.serPart,
    required this.serPct,
    required this.rad,
    required this.signTitle,
    required this.rate,
    required this.value,
    required this.psw,
    required this.accBank,
    required this.gradName,
    required this.beg2,
    required this.bal2,
    required this.userName,
    required this.cUser,
    required this.insipName,
    required this.enName,
    required this.noOutPatn,
    required this.oc,
    required this.tax1,
    required this.tax2,
    required this.tax3,
    required this.timeShare,
    required this.floor,
    required this.cur,
    required this.taxAc,
    required this.emer,
    required this.accCode2,
    required this.suspen,
    required this.suspend,
    required this.pict,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doc: json['DOC'],
      name: json['NAME'],
      insipId: json['INSIP_id'],
      gradeId: json['grade_id'],
      accCode: json['acc_CODE'],
      phoneHome1: json['PHONE_home1'],
      phoneHome2: json['PHONE_home2'],
      phoneClinic1: json['phone_clinic1'],
      phoneClinic2: json['phone_clinic2'],
      addClinic1: json['add_clinic1'],
      addClinic2: json['add_clinic2'],
      timeClinic1: json['time_clinic1'],
      timeClinic2: json['time_clinic2'],
      mobile: json['Mobile'],
      addHome: json['ADD_home'],
      email: json['email'],
      remarks: json['remarks'],
      price1: json['price1'],
      price2: json['price2'],
      price3: json['price3'],
      curBal: json['cur_bal'],
      opBal: json['op_bal'],
      nameEn: json['name_en'],
      medRemark: json['med_remark'],
      serPart: json['ser_part'],
      serPct: json['ser_pct'],
      rad: json['rad'],
      signTitle: json['sign_title'],
      rate: json['rate'],
      value: json['value'],
      psw: json['psw'],
      accBank: json['acc_bank'],
      gradName: json['Grad_name'],
      beg2: json['beg2'],
      bal2: json['bal2'],
      userName: json['user_name'],
      cUser: json['CUser'],
      insipName: json['insip_name'],
      enName: json['en_name'],
      noOutPatn: json['no_out_patn'],
      oc: json['OC'],
      tax1: json['tax1'],
      tax2: json['tax2'],
      tax3: json['tax3'],
      timeShare: json['time_share'],
      floor: json['floor'],
      cur: json['cur'],
      taxAc: json['tax_ac'],
      emer: json['emer'],
      accCode2: json['acc_code2'],
      suspen: json['suspen'],
      suspend: json['suspend'],
      pict: json['pict'],
    );
  }
}
