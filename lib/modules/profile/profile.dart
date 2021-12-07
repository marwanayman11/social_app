import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:social_app/modules/lovers/lovers.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class ProfileScreen extends StatelessWidget {
  final String id;
  ProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUser(id);
      SocialCubit.get(context)
          .getOtherPosts(SocialCubit.get(context).userModel1);
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            RefreshController _refreshController =
                RefreshController(initialRefresh: false);
            void _onRefresh() async {
              // monitor network fetch
              await Future.delayed(Duration(milliseconds: 1000));
              // if failed,use refreshFailed()
              SocialCubit.get(context).getUser(id);
              SocialCubit.get(context)
                  .getOtherPosts(SocialCubit.get(context).userModel1);
              _refreshController.refreshCompleted();
            }

            void _onLoading() async {
              // monitor network fetch
              await Future.delayed(Duration(milliseconds: 1000));
              // if failed,use loadFailed(),if no data return,use LoadNodata()

              _refreshController.loadComplete();
            }

            if (SocialCubit.get(context).userModel1 == null) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SmartRefresher(
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
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showImageViewer(
                                  context,
                                  Image.network(
                                          '${SocialCubit.get(context).userModel1!.cover}')
                                      .image,
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
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  '${SocialCubit.get(context).userModel1!.cover}')),
                                        )),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          radius: 65,
                                          child: InkWell(
                                            onTap: () {
                                              showImageViewer(
                                                  context,
                                                  Image.network(
                                                      '${SocialCubit.get(context).userModel1!.image}')
                                                      .image,
                                                  onViewerDismissed: () {});
                                            },
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage: NetworkImage(
                                                  '${SocialCubit.get(context).userModel1!.image}'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: MaterialButton(
                                            onPressed: () {
                                              if (SocialCubit.get(context)
                                                  .userModel1!
                                                  .followers!
                                                  .contains(
                                                      SocialCubit.get(context)
                                                          .userModel!
                                                          .uId)) {
                                                SocialCubit.get(context)
                                                    .unFollowUser(
                                                        SocialCubit.get(
                                                                context)
                                                            .userModel1!);
                                              } else {
                                                SocialCubit.get(context)
                                                    .followUser(
                                                        SocialCubit.get(
                                                                context)
                                                            .userModel1!);
                                                SocialCubit.get(context)
                                                    .createNotification(
                                                        id: SocialCubit.get(
                                                                context)
                                                            .userModel1!
                                                            .uId!,
                                                        text: 'followed you',
                                                        dateTime: DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now()));
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(SocialCubit.get(
                                                            context)
                                                        .userModel1!
                                                        .uId)
                                                    .update({
                                                      'notification': true
                                                    })
                                                    .then((value) {})
                                                    .catchError((error) {});
                                              }
                                            },
                                            child: Text(
                                              '${SocialCubit.get(context).userModel1!.followers!.contains(SocialCubit.get(context).userModel!.uId) ? 'Following' : 'Follow'}',
                                              style: GoogleFonts.actor(
                                                color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${SocialCubit.get(context).userModel1!.name}',
                            style: GoogleFonts.actor(
                                color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${SocialCubit.get(context).userModel1!.bio}',
                            style: GoogleFonts.actor(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Posts',
                                          style: GoogleFonts.actor(
                                              fontWeight: FontWeight.bold,
                                              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${SocialCubit.get(context).otherPosts.length}',
                                          style: GoogleFonts.actor(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Followers',
                                          style: GoogleFonts.actor(
                                              fontWeight: FontWeight.bold,
                                              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${SocialCubit.get(context).userModel1!.followersCount}',
                                          style: GoogleFonts.actor(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Following',
                                          style: GoogleFonts.actor(
                                              fontWeight: FontWeight.bold,
                                              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${SocialCubit.get(context).userModel1!.followingCount}',
                                          style: GoogleFonts.actor(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SocialCubit.get(context).otherPosts.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => postItem(
                                      SocialCubit.get(context)
                                          .otherPosts[index],
                                      context,
                                      index),
                                  itemCount: SocialCubit.get(context)
                                      .otherPosts
                                      .length)
                              : Padding(
                                  padding: const EdgeInsets.only(top: 70),
                                  child: Center(
                                      child: Icon(
                                    Icons.menu,
                                    color: Colors.blue,
                                    size: 150,
                                  )),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          });
    });
  }
}

Widget postItem(PostModel model, context, index) => Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 5),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      crossAxisAlignment: model.lang == 'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.name}',
                          style: GoogleFonts.actor(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
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
                    if (model.uId == SocialCubit.get(context).userModel!.uId)
                      IconButton(
                          onPressed: () {
                            SocialCubit.get(context).removePost(model.postId!);
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            size: 20,
                            color: Colors.grey,
                          ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '${model.text}',
                    style: GoogleFonts.actor(
                        color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.5),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // SizedBox(
                if (model.postImage != null)
                  Image(image: NetworkImage('${model.postImage}')),
                Row(
                  children: [
                    Card(
                      elevation: 5,
                      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            pushTo(
                                context,
                                CommentsScreen(
                                  postId: model.postId!,
                                  uId: model.uId!,
                                ));
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
                            pushTo(
                                context, LoversScreen(postId: model.postId!));
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
                        pushTo(
                            context,
                            CommentsScreen(
                              postId: model.postId!,
                              uId: model.uId!,
                            ));
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
                            style: GoogleFonts.actor(color: Colors.grey),
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
                              if (model.isLiked!.contains(
                                  SocialCubit.get(context).userModel!.uId)) {
                                SocialCubit.get(context)
                                    .unLikePost(model.postId!);
                              } else {
                                SocialCubit.get(context)
                                    .likePost(model.postId!);
                                SocialCubit.get(context).createNotification(
                                    id: model.uId!,
                                    text: 'liked your post',
                                    dateTime: DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now()),
                                    postId: model.postId!);
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
        ),
      );
    });
