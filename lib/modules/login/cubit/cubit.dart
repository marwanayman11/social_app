import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit(): super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);
  bool passVis=true;
  void changePassVis() {
    passVis = !passVis;
    emit(ChangePassVisState());
  }
  UserModel? userModel;
  void login ({required String email,required String password})async{
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
      userModel=UserModel(uId: value.user!.uid);
      emit(LoginSuccessState(userModel));
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });

  }

}