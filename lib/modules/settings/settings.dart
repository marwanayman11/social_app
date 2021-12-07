import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comment/comment.dart';
import 'package:social_app/modules/editprofile/editprofile.dart';
import 'package:social_app/modules/followers/followers.dart';
import 'package:social_app/modules/following/following.dart';
import 'package:social_app/modules/lovers/lovers.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
        return Builder(
          builder: (context) {
            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getProfilePosts();
            return BlocConsumer<SocialCubit,SocialStates>(
              listener: (context,state){
              },
              builder:(context,state){
                var model =SocialCubit.get(context).userModel;
                RefreshController _refreshController =
                RefreshController(initialRefresh: false);

                void _onRefresh() async{
                  // monitor network fetch
                  await Future.delayed(Duration(milliseconds: 1000));
                  // if failed,use refreshFailed()
                  SocialCubit.get(context).getUserData();
                  SocialCubit.get(context).getProfilePosts();
                  _refreshController.refreshCompleted();
                }

                void _onLoading() async{
                  // monitor network fetch
                  await Future.delayed(Duration(milliseconds: 1000));
                  // if failed,use loadFailed(),if no data return,use LoadNodata()

                  _refreshController.loadComplete();
                }
                return SmartRefresher(
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            showImageViewer(context,
                                Image.network('${model!.cover}').image,
                                onViewerDismissed: () {});
                          },
                          child: SizedBox(
                            height: 240,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 180,
                                      width: double.infinity,
                                      decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                        image: NetworkImage(
                                            '${model!.cover}')),
                                  )),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        radius: 65,
                                        child: InkWell(
                                          onTap: (){
                                            showImageViewer(context,
                                                Image.network('${model.image}').image,
                                                onViewerDismissed: () {});
                                          },
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                                '${model.image}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: InkWell(
                                        onTap: (){
                                          pushTo(context,  const EditProfileScreen());
                                        },
                                        child: Container(

                                          height: 30,
                                          decoration: BoxDecoration(
                                              color:CacheHelper.getData(key: 'theme')?Colors.grey[900]: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                 Icon(Icons.edit,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 5,),
                                                Text('Edit Profile',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),)
                                              ],),
                                          ),
                                        ),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text('${model.name}',style: GoogleFonts.actor(color:CacheHelper.getData(key: 'theme')?Colors.white: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 5,),
                        Text('${model.bio}',style: GoogleFonts.actor(fontSize: 15),),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:
                      Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Posts',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color:CacheHelper.getData(key: 'theme')?Colors.white: Colors.black),),
                                      SizedBox(height: 5,),
                                      Text('${SocialCubit.get(context).profilePosts.length}',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color: Colors.grey),),
                                    ],),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  pushTo(context, FollowersScreen());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Followers',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color:CacheHelper.getData(key: 'theme')?Colors.white: Colors.black),),
                                        SizedBox(height: 5,),
                                        Text('${model.followersCount}',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color: Colors.grey),),
                                      ],),
                                  ),
                                ),),
                            ),
                            const SizedBox(width: 20,),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  pushTo(context, FollowingScreen());

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:CacheHelper.getData(key: 'theme')?Colors.grey[900]: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Following',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),),
                                        SizedBox(height: 5,),
                                        Text('${model.followingCount}',style: GoogleFonts.actor(fontWeight: FontWeight.bold,color: Colors.grey),),
                                      ],),
                                  ),
                                ),),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        SocialCubit.get(context).profilePosts.isNotEmpty?ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => postItem(
                                SocialCubit.get(context).profilePosts[index],
                                context,
                                index),
                            itemCount: SocialCubit.get(context).profilePosts.length):Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Center(child: Icon(Icons.menu,color: Colors.blue,size: 150,

                          ),),
                        )

                      ],
                    ),
              ),
                  ),
                );}
            );
          }
        );
      }
}
Widget postItem(PostModel model, context, index) => Builder(builder: (context)  {
  return Card(
    color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
    elevation: 5,
    margin: const EdgeInsets.symmetric(vertical: 5),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:model.lang=='ar'?CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    style: GoogleFonts.actor(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:CacheHelper.getData(key: 'theme')?Colors.white: Colors.black,
                        height: 1),
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
              const Spacer(),
              if(model.uId==SocialCubit.get(context).userModel!.uId)
                IconButton(
                    onPressed: () {
                      SocialCubit.get(context).removePost(
                          model.postId!);
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      size: 20,
                      color:Colors.grey,
                    ))
            ],
          ),
          if (model.text != null)
            const SizedBox(
              height: 5,
            ),
          if (model.text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '${model.text}',
                style: GoogleFonts.actor(
                    color:CacheHelper.getData(key: 'theme')?Colors.white: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.5),
              ),
            ),

          // SizedBox(
          if (model.text != ""&&model.postImage!=null)
            const SizedBox(
              height: 10,
            ),
          if (model.postImage != null)
            InkWell(
              child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image(
                    image: NetworkImage('${model.postImage}'),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )),
              onTap: () {
                showImageViewer(context,
                    Image.network('${model.postImage}').image,
                    onViewerDismissed: () {});
              },
            ),
          SizedBox(height: 10,),
          Row(
            children: [
              Card(
                color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      pushTo(context, CommentsScreen(postId:model.postId!,uId: model.uId!,));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.comment,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${model.commentsCount}',
                          style: GoogleFonts.actor(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Card(
                color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,

                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      pushTo(context, LoversScreen(postId: model.postId));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${model.likesCount}',
                          style: GoogleFonts.actor(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  pushTo(context, CommentsScreen(postId:model.postId!,uId: model.uId!,));

                },
                child: Row(
                  children: [
                    Icon(

                      Icons.comment,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Comment',
                      style: GoogleFonts.actor(
                          color: Colors.grey
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),

              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if(model.isLiked!.contains(SocialCubit.get(context).userModel!.uId)){
                          SocialCubit.get(context).unLikePost(model.postId!);

                        }
                        else{
                          SocialCubit.get(context).likePost(model.postId!);
                        }
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: model.isLiked!.contains(
                            SocialCubit.get(context).userModel!.uId)
                            ? Colors.red
                            : Colors.grey,
                        size: 25,
                      ))
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
});
