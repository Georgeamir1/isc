import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:isc/shared/componants.dart';
import '../Screens/Booking/Booking_list.dart';
import '../State_manage/Cubits/cubit.dart';
import '../State_manage/States/States.dart';
//..............................................................................

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

//..............................................................................

class _MainPageState extends State<MainPage> {
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedUser;
  String? _errorMessage;
  @override
//..............................................................................
  void initState() {
    super.initState();
    context.read<getDataCubit>().getdata();
  }
//..............................................................................
  Future<void> _refreshData() async {
    context.read<getDataCubit>().getdata();
  }
//..............................................................................
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:
      BlocConsumer<getDataCubit, getLoginDataStates>(
        listener: (context, state) {
          if (state is getLoginDataErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Network Error')),
            );
          }
        },
        //......................................................................
        builder: (context, state) {
          final cubit = context.read<getDataCubit>();
          List<String> userNames = [];
          if (state is getLoginDataSucessState) {
            userNames = state.Data.map((user) => user['UserName'] as String).toList();}
          //....................................................................
          return Padding(
            padding: const EdgeInsets.all(60.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 160,
                    width: 160,
                  ),
                  //............................................................
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightBlue, Colors.indigo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(4, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'ORCHIDA CLINIC',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //............................................................
                  SizedBox(height: 80),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownSearch<String>(
                      items: userNames,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: "Select User",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                      ),
                      selectedItem: _selectedUser,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) => ListTile(
                          title: Text(item),
                          selected: isSelected,
                        ),
                      ),
                      filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedUser = newValue;
                          if (newValue != null) {
                            cubit.selectUser(newValue);
                          }
                          _errorMessage = null; // Clear any previous error message
                        });
                      },
                    ),
                  ),
                  //............................................................
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      obscureText: true,
                    ),
                  ),
                  //............................................................
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlue, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        final password = _passwordController.text;
                        if (_selectedUser != null) {
                          if (cubit.validatePassword(password)) {
                            setState(() {
                              _errorMessage = 'Password is correct!';
                        navigateToPage(context, BookingList(),);
                            });
                          } else {
                            setState(() {
                              _errorMessage = 'Password is incorrect!';

                            });
                          }
                        } else {
                          setState(() {
                            _errorMessage = 'Please select a user .';
                          });
                        }
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                  //............................................................
                  SizedBox(height: 20),
                  if (_errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _errorMessage == 'Password is correct!'
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _errorMessage == 'Password is correct!'
                              ? Colors.green
                              : Colors.red,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _errorMessage == 'Password is correct!'
                                ? Icons.check_circle
                                : Icons.error,
                            color: _errorMessage == 'Password is correct!'
                                ? Colors.green
                                : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: _errorMessage == 'Password is correct!'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  //............................................................
                ],
              ),  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.white,
        tooltip: 'Refresh Data',
      ),
      //............................................................
    );
  }
//..............................................................................
}

//..............................................................................
