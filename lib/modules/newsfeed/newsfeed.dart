import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comment/comment.dart';
import 'package:social_app/modules/lovers/lovers.dart';
import 'package:social_app/modules/profile/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getPosts();
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            RefreshController _refreshController =
                RefreshController(initialRefresh: false);

            void _onRefresh() async {
              // monitor network fetch
              await Future.delayed(Duration(milliseconds: 1000));
              // if failed,use refreshFailed()
              SocialCubit.get(context).getPosts();
              _refreshController.refreshCompleted();
            }

            void _onLoading() async {
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
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        items: [
                          Image(
                              width: double.infinity,
                              height: double.infinity,
                              image: NetworkImage(
                                  'https://educationinprogress.eu/images/social_media.png')),
                          // Image(
                          //     width: double.infinity,
                          //     image: NetworkImage(
                          //         'https://www.gannett-cdn.com/presto/2021/10/15/PWTR/bccb4a1c-e697-4b4c-9952-08d40f68ccf2-Social_media_detox_challenge1.jpg?crop=1116,628,x41,y0&width=1116&height=628&format=pjpg&auto=webp')),
                          Image(
                              width: double.infinity,
                              image: NetworkImage(
                                  'https://cdn.searchenginejournal.com/wp-content/uploads/2021/08/top-5-reasons-why-you-need-a-social-media-manager-616015983b3ba-sej.png')),
                        ],
                        options: CarouselOptions(
                          aspectRatio: 21 / 11,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          // onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      SocialCubit.get(context).posts.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => postItem(
                                      SocialCubit.get(context).posts[index],
                                      context,
                                      index),
                                  itemCount:
                                      SocialCubit.get(context).posts.length),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 150),
                              child: Center(
                                child: Icon(
                                  Icons.home,
                                  color: Colors.blue,
                                  size: 150,
                                ),
                              ),
                            )
                    ],
                  )),
            );
          });
    });
  }
}

Widget postItem(PostModel model, context, index) => Builder(builder: (context) {
      return Card(
        color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: model.lang == 'ar'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      pushTo(context, ProfileScreen(id: model.uId!));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${model.image}'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          pushTo(context, ProfileScreen(id: model.uId!));
                        },
                        child: Text(
                          '${model.name}',
                          style: GoogleFonts.actor(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                              height: 1),
                        ),
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
              if (model.text != "" || model.postImage != null)
                const SizedBox(
                  height: 5,
                ),
              if (model.text != "")
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

              // SizedBox(
              if (model.text != "" && model.postImage != null)
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
                    showImageViewer(
                        context, Image.network('${model.postImage}').image,
                        onViewerDismissed: () {});
                  },
                ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Card(
                    color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
                    elevation: 5,
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
                              context,
                              LoversScreen(
                                postId: model.postId,
                              ));
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
                              SocialCubit.get(context).likePost(model.postId!);
                              SocialCubit.get(context).createNotification(
                                  id: model.uId!,
                                  text: 'liked your post',
                                  dateTime: DateFormat('dd-MM-yyyy hh:mm:ss a')
                                      .format(DateTime.now()),
                                  postId: model.postId!);
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(model.uId)
                                  .update({'notification': true})
                                  .then((value) {})
                                  .catchError((error) {});
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
