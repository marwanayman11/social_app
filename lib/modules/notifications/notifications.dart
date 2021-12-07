import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/modules/post/post.dart';
import 'package:social_app/modules/profile/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          SocialCubit.get(context).getNotifications();
          return BlocConsumer<SocialCubit, SocialStates>(
              builder: (context, state) {
                RefreshController _refreshController =
                RefreshController(initialRefresh: false);

                void _onRefresh() async{
                  // monitor network fetch
                  await Future.delayed(Duration(milliseconds: 1000));
                  // if failed,use refreshFailed()
                  SocialCubit.get(context).getNotifications();
                  _refreshController.refreshCompleted();
                }

                void _onLoading() async{
                  // monitor network fetch
                  await Future.delayed(Duration(milliseconds: 1000));
                  // if failed,use loadFailed(),if no data return,use LoadNodata()

                  _refreshController.loadComplete();
                }
                return Scaffold(
                  appBar: AppBar(title: Text('Notifications',style: GoogleFonts.actor()),),
                  body: SocialCubit.get(context).notifications.isEmpty?
                Center(child: Icon(Icons.notifications,color: Colors.blue,size: 150,

                ),):

                SmartRefresher(
                  physics: BouncingScrollPhysics(),
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    waterDropColor: Colors.blue,
                    refresh: CircularProgressIndicator(),
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: SocialCubit.get(context).notifications.length,
                  itemBuilder: (context, index) => notificationItem(SocialCubit.get(context).notifications[index],context),
                  separatorBuilder: (context, index) => Container(
                  width: double.infinity, height: 2, color: Colors.grey),
                  ),
                ),
                );

              },
              listener: (context, state) {});
        }
    );
  }

}

Widget notificationItem(NotificationModel model, context) => Builder(builder: (context) {
  return InkWell(
    onTap: (){
      if(model.text=='followed you'){
        pushTo(context, ProfileScreen(id: model.senderId!));
      }
      else{
        pushTo(context, PostScreen(postId:model.postId!));
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical:  10.0,horizontal: 5),
      child: Card(
        elevation: 5,
          color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  pushTo(context, ProfileScreen(id: model.senderId!));
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('${model.senderImage}'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          pushTo(context, ProfileScreen(id: model.senderId!));
                        },
                        child: Text(
                          '${model.senderName}',
                          style: GoogleFonts.actor(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                              height: 1),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        '${model.text}',
                        style: GoogleFonts.actor(
                            color:CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            height: 1.5),
                      ),
                    ],
                  ),
                  Text(
                    '${model.dateTime}',
                    style: GoogleFonts.actor(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        height: 1.5),
                  )
                ],
              ),
            ]),
      )),
    ),
  );
});


