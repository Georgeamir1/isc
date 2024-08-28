import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/bloc_ovserver.dart';
import 'package:isc/test/draft.dart';
import 'Home/Booking/Booking_list.dart';
import 'Home/Booking/edit_Booking.dart';
import 'Home/home/Home.dart';
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
      home: Home(),
    );
  }
}
