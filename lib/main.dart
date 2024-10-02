import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/bloc_ovserver.dart';
import 'Home/Booking/Booking_list.dart';
import 'Home/Medical_Records/meds.dart';
import 'Home/Medical_Records/records.dart';
import 'Home/home/Home.dart';
import 'Home/home/Medical Records.dart';
import 'Screens/test.dart';
import 'auth/signin_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc.observer = MyBlocObserver();
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disable debug banner here
      home: MainPage(),
    );
  }
}