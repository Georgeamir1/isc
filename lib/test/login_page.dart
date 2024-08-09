// // login_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'user_bloc.dart';
// import 'user_model.dart';
// import 'user_service.dart'; // Make sure to import this
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _passwordController = TextEditingController();
//   User? _selectedUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: BlocProvider(
//         create: (context) => UserBloc(UserService())..add(FetchUsers()),
//         child: BlocBuilder<UserBloc, UserState>(
//           builder: (context, state) {
//             if (state is UserLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is UserLoaded) {
//               return _buildLoginForm(state.users);
//             } else if (state is UserError) {
//               return Center(child: Text('Error: ${state.error}'));
//             }
//             return Center(child: Text('Please wait...'));
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginForm(List<User> users) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           DropdownButtonFormField<User>(
//             decoration: InputDecoration(
//               labelText: 'Select User',
//               border: OutlineInputBorder(),
//             ),
//             items: users.map((user) {
//               return DropdownMenuItem<Usermodel1>(
//               );
//             }).toList(),
//             onChanged: (user) {
//               setState(() {
//                 _selectedUser = user;
//               });
//             },
//             value: _selectedUser,
//           ),
//           SizedBox(height: 20),
//           TextFormField(
//             controller: _passwordController,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               border: OutlineInputBorder(),
//             ),
//             obscureText: true,
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _login,
//             child: Text('Login'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _login() {
//     if (_selectedUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a user')),
//       );
//       return;
//     }
//     // Implement your login logic here
//     // You can use the _selectedUser and _passwordController.text values
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Login Successful for ${_selectedUser!.username}')),
//     );
//   }
// }
