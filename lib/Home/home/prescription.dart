import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isc/shared/componants.dart';
import '../../State_manage/Cubits/cubit.dart';
import '../../State_manage/States/States.dart';
import '../../shared/Data.dart';

class prescreption extends StatelessWidget {
  final TextEditingController DiscriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getDoctorDataCubit()),
        BlocProvider(create: (BuildContext context) => AnimationCubit()),

      ],
      child: BlocConsumer<getDoctorDataCubit, getDoctorDataStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          isExpanded = false;
          return Scaffold(
            appBar:PreferredSize(preferredSize: Size(double.infinity, double.maxFinite), child:
            BlocBuilder<AnimationCubit, AnimationState>(
                builder: (context, state) {
                  int hight = 100;
                  return  AnimatedContainer(
                    curve: Curves. fastEaseInToSlowEaseOut,
                    height: isExpanded ? (iscollabsed? 400 :350) : 100,
                    duration: Duration(milliseconds: 500),
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

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            title: Text(
                              'prescreption',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            actions: [
                              IconButton(
                                icon:
                                Icon(
                                  isExpanded ? Icons.cancel : Icons.add_circle,
                                  color: Colors.white,
                                  size: 35,
                                  shadows: [
                                    Shadow(color: Colors.white.
                                    withOpacity(0.2),
                                      offset: Offset(0, 4),
                                      blurRadius: 8,)],),
                                onPressed: () {
                                  context.read<AnimationCubit>().selectAddAnimation();

                                },
                              ),
                            ],
                          ),
                          if (isExpanded )

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 40,),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      context.read<AnimationCubit>().selectAdd2Animation();
                                    },
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                        color: Colors.white,

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            spreadRadius: 2,
                                            blurRadius: 9,
                                            offset: Offset(4, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      duration: Duration(milliseconds: 200),
                                      height:iscollabsed?120: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(child: Text('Prescreption',
                                        style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.bold),)),


                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  GestureDetector(
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            spreadRadius: 2,
                                            blurRadius: 9,
                                            offset: Offset(4, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      duration: Duration(milliseconds: 200),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,

                                      child: Center(child: Text('medical record',
                                        style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.bold),
                                      )),


                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  GestureDetector(
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            spreadRadius: 2,
                                            blurRadius: 9,
                                            offset: Offset(4, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      duration: Duration(milliseconds: 200),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,

                                      child: Center(child: Text('Service',style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.bold),)),


                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                }
            ),
            ),
            body:
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ReusableTextFormField(
                      controller: DiscriptionController,
                      onChanged: (p0) {

                      },
                      hintText: 'Discription...',)
                ],
              ),
            ),


          );
          ;
        },
      ),
    );
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
