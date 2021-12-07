import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool passVis = true;
  void changePassVis() {
    passVis = !passVis;
    emit(Change1PassVisState());
  }

  void register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(name: name, email: email, phone: phone, uId: value.user!.uid);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  Future<void> createUser(
      {required String name,
      required String email,
      required String phone,
      required String uId}) async {
    UserModel model = UserModel(
        phone: phone,
        name: name,
        email: email,
        uId: uId,
        bio: 'Write your bio ...',
        cover:'https://htmlcolors.com/palette-image/45/facebook-cover.png',
        image:
            'https://www.donkey.bike/wp-content/uploads/2020/12/user-member-avatar-face-profile-icon-vector-22965342-300x300.jpg',
        isEmailVerified: false,
        fcm: await FirebaseMessaging.instance.getToken(),
        followers: [],
        following: [],
      followersCount: 0,
      followingCount: 0,
      notification: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState(model));
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
