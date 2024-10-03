import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:isc/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../State_manage/Cubits/cubit.dart';
import '../State_manage/States/States.dart';
import '../shared/Data.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _passwordController = TextEditingController();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  bool showpassword = true;

  void _onRefresh(BuildContext context) async {
    // Simulate refreshing your data
    await Future.delayed(
        Duration(milliseconds: 1000)); // Simulate network delay
    context.read<getDataCubit>().getdata();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getDataCubit()..getdata(),
        ),
        BlocProvider(
          create: (context) => ShowPasswordcubit(),
        ),
      ],
      child: Directionality(
        textDirection: isArabicsaved?TextDirection.rtl:TextDirection.ltr,
        child: Scaffold(
          backgroundColor: isDarkmodesaved ? Color(0xff232323) : Colors.grey[50],
          body: BlocConsumer<getDataCubit, getLoginDataStates>(
            listener: (context, state) {
              if (state is getLoginDataErrorState) {
                print('${state.error}');
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
                userNames =
                    state.Data.map((user) => user['User_Name'] as String).toList();
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
                        child: isDarkmodesaved
                            ? Image.asset(
                          'assets/images/icon dark2.png',
                          height: 200,
                          width: 200,
                        )
                            : Image.asset(
                          'assets/images/icon light.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: CustomblueContainer(
                          Radius: 15,
                          height: 65,
                          padding: EdgeInsets.all(16),
                          child: Text(
                            isArabicsaved ? 'اوركيدا كلينك' : 'ORCHIDA CLINIC',
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
                      CustomwhiteContainer(
                        child: DropdownSearch<String>(
                          items: userNames,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            baseStyle: TextStyle(
                              color: isDarkmodesaved
                                  ? Colors.white
                                  : Colors.black45,
                            ),
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              hintText: isArabicsaved ? 'اختر مستخدم' : "Select User",
                              hintStyle: TextStyle(
                                color: isDarkmodesaved
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIconColor:
                              isDarkmode ? Colors.white : Colors.black45,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2),
                              ),
                            ),
                          ),
                          selectedItem: cubit.selectedUser,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              style: TextStyle(
                                color: isDarkmode ? Colors.white : Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: isArabicsaved ? 'ابحث' : 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) =>
                                ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      color: isDarkmodesaved
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: isSelected,
                                ),
                          ),
                          filterFn: (item, filter) =>
                              item.toLowerCase().contains(filter.toLowerCase()),
                          onChanged: (String? newValue) {
                            cubit.selectUser(newValue ?? '');
                          },
                          dropdownBuilder: (context, selectedItem) {
                            return Text(
                              selectedItem ??
                                  (isArabicsaved ? 'اختر مستخدم ' : 'Select User'),
                              style: TextStyle(
                                color: isDarkmodesaved
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ReusableTextFormField(
                        prefixIconButton: IconButton(
                          onPressed: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                          icon: Icon(
                            showpassword
                                ? Icons.remove_red_eye
                                : CupertinoIcons.eye_slash_fill,
                            color: isDarkmodesaved
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                        obscureText: showpassword,
                        controller: _passwordController,
                        onChanged: (p0) {},
                        hintText: isArabicsaved ? 'كلمه السر' : 'Enter Password',
                      ),
                      SizedBox(height: 120),
                      CustomblueContainer(
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
                            isArabicsaved ? 'تسجيل دخول' : 'Login',
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
      ),
    );
  }
}
