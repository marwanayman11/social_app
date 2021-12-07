import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:social_app/modules/login/login.dart';
import 'package:social_app/modules/newpost/newpost.dart';
import 'package:social_app/modules/notifications/notifications.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final iconList = <IconData>[
      Icons.home,
      Icons.search,
      Icons.chat_sharp,
      Icons.settings,
    ];
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUsers();
        SocialCubit.get(context).getPosts();
        SocialCubit.get(context).getProfilePosts();
        SocialCubit.get(context).getUserData();
        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder:(context,state){
            var cubit = SocialCubit.get(context);
            return SocialCubit.get(context).userModel==null?Scaffold(

              body: Center(child: CircularProgressIndicator(),),

            ): Scaffold(
              floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: () {
                pushTo(context, NewPost());
              },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: AnimatedBottomNavigationBar(
                backgroundColor: CacheHelper.getData(key: 'theme')?Colors.black:Colors.white,
                inactiveColor: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                elevation: 20,
                activeColor: Colors.blue,
                icons:iconList ,
                activeIndex: cubit.currentIndex,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.verySmoothEdge,
                leftCornerRadius: 32,
                rightCornerRadius: 32,
                onTap:(index){
                  cubit.changeBottomNav(index);
                },
                //other params
              ),
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex],style:GoogleFonts.actor(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(onPressed: (){
                  pushTo(context,  NotificationsScreen());
                  FirebaseFirestore.instance.collection('users').doc(SocialCubit.get(context).userModel!.uId).update({'notification':false}).then((value){}).catchError((error){});
                }, icon:Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    const Icon(Icons.notifications),
                    if(SocialCubit.get(context).userModel!.notification!)
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 5,
                    )
                  ],
                ),),
                IconButton(onPressed: (){
                  SocialCubit.get(context).changeTheme();
                }, icon:const Icon(Icons.brightness_4_rounded),),
                 IconButton(onPressed: (){
                   CacheHelper.clearData(key: 'uId');
                   pushToAndFinish(context,  LoginScreen());
                   FirebaseAuth.instance.signOut();
                 }, icon:const Icon(Icons.logout),),

              ],
            ),
              body: cubit.screens[cubit.currentIndex],

          );}
        );
      }
    );
  }
}
