import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isc/Home/Booking/Booking_list.dart';
import 'package:isc/Home/home/prescription.dart';

import '../../shared/componants.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return
      WillPopScope(
        onWillPop: () async {
          bool shouldExit = await _showExitConfirmationDialog(context);
          return shouldExit;
        },
        child:       Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.indigo],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0,left: 15),
                    child: Text(
                      'Home ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),),
                ),
                SizedBox(height: 30,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                    child:
                    Row(
                      children: [
                        Screens(screenname: "Reservations", onPressed: () {
                          navigateToPage(context, BookingList());
                        }, imagepath: 'assets/images/schedule.png',),
                        SizedBox(width: 18,),
                        Screens(screenname: "Medical Records", onPressed: () {
                          navigateToPage(context,prescreption());
                        }, imagepath: 'assets/images/medical records.png',),
                        SizedBox(width: 18,),
                      ],
                    ),
                  ),
                ),
                SizedBox( height: 40),

              ],
            ),
          ),


        ),
      );
  }

  void _goToSettingsPage(BuildContext context) {
    // Navigate to the home page

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => prescreption()),
    );
  }

  void _goToProfilePage(BuildContext context) {
    // Navigate to the profile page

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  prescreption()),
    );
  }

  void _goToNotificationsPage(BuildContext context) {


  }
}
Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Exit App'),
      content: Text('Are you sure you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: (){ exit(0);},
          child: Text('Yes'),
        ),
      ],
    ),
  ) ?? false;
}
