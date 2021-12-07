import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comment/comment.dart';
import 'package:social_app/modules/lovers/lovers.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class PostScreen extends StatelessWidget {
  final String postId;
  const PostScreen({Key? key, required this.postId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getPost(postId);
      return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Post', style: GoogleFonts.actor()),
                ),
                body: SocialCubit.get(context).model == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : postItem(SocialCubit.get(context).model, context));
          },
          listener: (context, state) {});
    });
  }
}

Widget postItem(PostModel? model, context) => Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 5, left: 5),
        child: Card(
          elevation: 5,
          color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${model!.image}'),
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
                      elevation: 5,
                      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            pushTo(
                                context,
                                LoversScreen(
                                  postId: model.postId!,
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
                                SocialCubit.get(context)
                                    .likePost(model.postId!);
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
