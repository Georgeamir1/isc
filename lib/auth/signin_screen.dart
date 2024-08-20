import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../State_manage/Cubits/cubit.dart';
import '../State_manage/States/States.dart';

class MainPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh(BuildContext context) async {
    // Refresh your data here
    await Future.delayed(Duration(milliseconds: 1000)); // Simulate network delay
    context.read<getDataCubit>().getdata();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getDataCubit()..getdata(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: BlocConsumer<getDataCubit, getLoginDataStates>(
          listener: (context, state) {
            if (state is getLoginDataErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Network Error: ${state.error}')),
              );
            } else if (state is getLoginDataSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<getDataCubit>();
            List<String> userNames = [];
            if (state is getLoginDataSucessState) {
              userNames = state.Data.map((user) => user['NAME'] as String).toList();
            }

            return SmartRefresher(
              controller: _refreshController,
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/images/icon 1.png',
                        height: 160,
                        width: 160,
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
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
                    SizedBox(height: 50),
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
                      child:
                      DropdownSearch<String>(
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
                        selectedItem: cubit.selectedUser,
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
                          cubit.selectUser(newValue ?? '');
                        },
                      ),
                    ),
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
                    SizedBox(height: 60),
                    Container(
                      width: double.infinity,
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
                          cubit.submitForm(password, context);
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
