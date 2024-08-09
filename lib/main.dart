import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/bloc_ovserver.dart';
import 'package:isc/test/login_page.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';
import 'Screens/Booking/Booking_New.dart';
import 'Screens/Booking/Booking_list.dart';
import 'State_manage/Cubits/cubit.dart';
import 'auth/signin_screen.dart';
import 'onboarding/test.dart';
import 'onboarding/test2.dart'; // Import your MainPage file

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
