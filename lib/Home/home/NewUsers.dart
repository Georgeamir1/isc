// import 'package:board_datetime_picker/board_datetime_picker.dart';
// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:isc/Home/Booking/Booking_New.dart';
// import 'package:isc/Home/home/BaicData.dart';
// import 'package:isc/shared/componants.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import '../../State_manage/Cubits/cubit.dart';
// import '../../State_manage/States/States.dart';
// import '../../shared/Data.dart';
// import '../Booking/Booking_list.dart';
//
// class NewUsers extends StatelessWidget {
//   final RefreshController _refreshController = RefreshController(initialRefresh: false);
//   final TextEditingController UserNameControler = TextEditingController();
//   final TextEditingController UserPhoneControler = TextEditingController();
//   final TextEditingController UserEmailControler = TextEditingController();
//   final TextEditingController UserPasswordControler = TextEditingController();
//   final TextEditingController UserAddressControler = TextEditingController();
//   final TextEditingController UserTybeControler = TextEditingController();
//   final TextEditingController DoctorSpecializationControler = TextEditingController();
//   final ValueNotifier<DateTime> dateNotifier = ValueNotifier<DateTime>(DateTime.now());
//   final BoardDateTimeController dateTimeController = BoardDateTimeController();
//   final _formKey = GlobalKey<FormState>(); // Form key
//   bool isSelected = false;
//
//   int? code;
//
//   @override
//   Widget build(BuildContext context) {
//     // Listen to changes in dateNotifier and update the Date variable
//     dateNotifier.addListener(() {
//       final dateTime = dateNotifier.value;
//
//       if (dateTime != null) {
//         final dateString = BoardDateFormat('yyyy/MM/dd h:mm a').format(dateTime);
//         final hour = dateTime.hour;
//         String dayType = hour >= 6 && hour < 12 ? 'Morning' : 'Night';
//
//         // Update Date and DayType variables
//         Date = dateString;
//         DayType = dayType;
//       }
//     });
//
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (BuildContext context) => getDoctorDataCubit()..getDoctors()),
//         BlocProvider(create: (BuildContext context) => getpatientDataCubit()),
//         BlocProvider(create: (BuildContext context) => BookingCubit()),
//         BlocProvider(create: (BuildContext context) => getDataCubit())
//       ],
//       child: BlocConsumer<getDoctorDataCubit, getDoctorDataStatus>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           getDataCubit.get(context).getdata();
//           int? Ulength = getDataCubit.get(context).getLargestUserId()?.toInt();
//           print(Ulength);
//           int Dlenght =getDoctorDataCubit.get(context).Doctors.length??0;
//           print(Dlenght);
//
//           return Scaffold(
//             backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
//             resizeToAvoidBottomInset: true,
//             appBar:CustomAppBar(title: 'New User',) ,
//             body: SingleChildScrollView(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey, // Assign form key
//                 child: Column(
//                   children: [
//                     ReusableTextFormField(
//                       height: 50,
//                         maxLenght: 250,
//                         controller: UserNameControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Name';
//                           }
//                         },
//                         hintText: 'User Name'), const SizedBox(height: 20),
//                     ReusableTextFormField(
//                         height: 50,
//                         maxLenght: 11,
//                         keyboardType: TextInputType.number,
//                         controller: UserPhoneControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Phone';
//                           }
//                           else if(value.length != 11)
//                           {
//                             return'please enter 14 number';
//                           }
//                         },
//                         hintText: 'Mobile Number'), const SizedBox(height: 20),
//                     ReusableTextFormField(
//                         height: 50,
//                         maxLenght: 400,
//                         controller: UserEmailControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Address';
//                           }
//                         },
//                         hintText: 'email'),const SizedBox(height: 20),
//                     ReusableTextFormField(
//                         height: 50,
//                         maxLenght: 400,
//                         controller: UserPasswordControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Address';
//                           }
//                         },
//                         hintText: 'Password'),const SizedBox(height: 20),
//                     ReusableTextFormField(
//                         height: 50,
//                         keyboardType: TextInputType.number,
//                         controller: UserAddressControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter address';
//                           }
//
//                         },
//                         hintText: 'address'), const SizedBox(height: 20),
//                     ReusableTextFormField(
//                         height: 50,
//                         maxLenght: 400,
//                         controller: UserTybeControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Type';
//                           }
//                         },
//                         hintText: 'USER TYPE'), const SizedBox(height: 60),
//                     // BlocBuilder<BookingCubit, Bookingtatus>(
//                     //   builder: (context, state) {
//                     //     isSelected = (state is Bookingswitchstate && state.isSelected);
//                     //
//                     //     return CustomwhiteContainer(
//                     //       height: 50,                          child: SwitchListTile(
//                     //         activeTrackColor: Colors.indigoAccent,
//                     //         title: Text(isSelected ? 'Male' : 'Female',
//                     //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.blueAccent:Colors.pinkAccent),
//                     //         ),
//                     //         value: isSelected,
//                     //         onChanged: (bool value) {
//                     //           BookingCubit.get(context).toogel();
//                     //         },
//                     //         inactiveTrackColor: Colors.pinkAccent,
//                     //         inactiveThumbColor: Colors.white,
//                     //       ),
//                     //     );
//                     //   },
//                     // ),const SizedBox(height: 20),
//                     ReusableTextFormField(
//                         height: 50,
//                         maxLenght: 400,
//                         controller: DoctorSpecializationControler,
//                         onChanged: (p0) {},
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Address';
//                           }
//                         },
//                         hintText: 'Specialization'),
//                     const SizedBox(height: 15 ),
//                     CustomblueContainer(
//                       Radius: 30,
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: () async{
//
//                           if (_formKey.currentState!.validate()) {
//                             getDataCubit.get(context).NewUser(
//                                 UerName: UserNameControler.text,
//                                 Phone: UserPhoneControler.text,
//                                 Address: UserAddressControler.text,
//                                 PSW: UserPasswordControler.text,
//                                 Email: UserEmailControler.text,
//                                 mob: UserPhoneControler.text,
//                                 ID: Ulength!+1);
//
//                                 // if (UserTybeControler.text == '1')
//                                 // {
//                                 //   getDoctorDataCubit.get(context).NewDoctor
//                                 //     (UerName: UserNameControler.text,
//                                 //       Insip_ID: DoctorSpecializationControler.text,
//                                 //       Address: UserAddressControler.text,
//                                 //       PSW: UserPasswordControler.text,
//                                 //       Email: UserEmailControler.text,
//                                 //       mob: UserPhoneControler.text,
//                                 //       ID: Dlenght+1);
//                                 // }
//
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   'Form Submitted Successfully',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                                 navigateToPage(context, Basicdata());
//                           } else {
//
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   'Please fill in all required fields',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         },
//
//
//                         icon: Icon(
//                           Icons.check_circle,
//                           color: Colors.white,
//                         ),
//                         label: Text(
//                           'Submit',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           elevation: 0,
//                           shadowColor: Colors.transparent,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           );
//         },
//       ),
//     );
//   }
// }
