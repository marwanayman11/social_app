import 'package:social_app/models/user_model.dart';

abstract class LoginStates{}
class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{
UserModel? userModel;
LoginSuccessState(this.userModel);
}
class LoginErrorState extends LoginStates{
  late final String error;
  LoginErrorState(this.error);
}
class ChangePassVisState extends LoginStates{}
