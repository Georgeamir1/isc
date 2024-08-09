// user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_model.dart';
import 'user_service.dart';

// Events
abstract class UserEvent {}

class FetchUsers extends UserEvent {}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<Usermodel1> users;

  UserLoaded(this.users);
}

class UserError extends UserState {
  final String error;

  UserError(this.error);
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc(this.userService) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await userService.fetchUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
