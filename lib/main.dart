import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/login/login.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/bloc_observer.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/styles/styles.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'modules/onboarding/onboarding.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showToast(message: 'New message from ${message.notification!.title} : ${message.notification!.body}', state: toastStates.success);
  print(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    if (FirebaseAuth.instance.currentUser != null) {
      final userID = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update({'fcm': newToken});
    }
  });

  FirebaseMessaging.onMessage.listen((event) {
    showToast(message: 'New message from ${event.notification!.title} : ${event.notification!.body}', state: toastStates.success);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(message: 'New message from ${event.notification!.title} : ${event.notification!.body}', state: toastStates.success);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheHelper.init();
  Widget onStart;
  if(CacheHelper.getData(key: 'onBoarding')==null){
    CacheHelper.saveData(key: 'onBoarding', value: false);
    onStart= const OnBoardingScreen();
  }
  else{
    if(CacheHelper.getData(key: 'uId')==null) {
      onStart=LoginScreen();
    } else{
      uId=CacheHelper.getData(key: 'uId');
      onStart=const HomeLayout();
    }
  }
  if(CacheHelper.getData(key: 'theme')==null){
    CacheHelper.saveData(key: 'theme', value: false);
  }
  else {
    CacheHelper.getData(key: 'theme');
  }
  runApp(MyApp(onStart: onStart,));
}

class MyApp extends StatelessWidget {
  final Widget onStart;
  const MyApp({Key? key, required this.onStart}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>SocialCubit(),
      child:BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){},
        builder: (context,state){
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:CacheHelper.getData(key: 'theme')? darkTheme:lightTheme,
            home:onStart,
            builder: BotToastInit(), //1. call BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()],
          );
        },
      )
      );

  }
}
