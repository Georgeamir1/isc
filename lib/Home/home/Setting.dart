import 'package:flutter/material.dart';
import 'package:isc/Home/home/Home.dart';
import 'package:isc/auth/signin_screen.dart';
import 'package:isc/shared/Data.dart';
import 'package:isc/shared/componants.dart';

class Setting extends StatefulWidget {

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  bool Language = false;
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitConfirmationDialog(context);
        return shouldExit;
      },
      child: Scaffold(

        backgroundColor: isDarkmode ? Color(0xff232323) : Colors.grey[50],
        appBar: CustomAppBar(title:  !isArabic ? 'Setting' :'الاعدادات',color: isDarkmode ? [Colors.indigo, Colors.deepPurple] : [Colors.lightBlue, Colors.indigo],),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomwhiteContainer(
              color:  isDarkmode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        isDarkmode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: isDarkmode? Colors.white :Colors.grey[850],
                      ),
                      SizedBox(width: 10),
                      Text(isArabic? isDarkmode ? 'الوضع الداكن' : 'الوضع الفاتح':isDarkmode ? 'Dark Mode' : 'Light Mode',style: TextStyle(
                        color:  isDarkmode? Colors.white :Colors.grey[850]
                      ),),
                      Spacer(),
                      Switch(
                        value: isDarkmode,
                        onChanged: (value) {
                          setState(() {
                            isDarkmode = !isDarkmode;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              CustomwhiteContainer(
                color:  isDarkmode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                         Icons.translate
                             ,color: isDarkmode? Colors.white :Colors.grey[850],
                      ),
                      SizedBox(width: 10),
                      Text(isArabic ? 'العربية' : 'English',style: TextStyle(  color: isDarkmode? Colors.white :Colors.grey[850]),),
                      Spacer(),
                      Switch(
                        value: isArabic,
                        onChanged: (value) {
                          setState(() {
                            isArabic = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    navigateToPage(context, MainPage());
                  },
                  child: CustomwhiteContainer(
                      color:  isDarkmode ? Colors.grey[800] : Colors.white,
                      height: 50,
                      child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(isArabic? 'تسجيل خروج':'Logout ',style: TextStyle(color:  isDarkmode?Colors.white:Colors.black45,fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                    ],
                  )),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Save'),
      content: Text('Do you want to save changes?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            isDarkmode   = isDarkmodesaved;
            isArabic  = isArabicsaved;
          },
          child: Text('No'),

        ),
        TextButton(
          onPressed: (){
            navigateToPage(context, Home());
            isDarkmodesaved = isDarkmode;
            isArabicsaved  = isArabic;

          },
          child: Text('Yes'),

        ),
      ],
    ),
  ) ?? false;
}
