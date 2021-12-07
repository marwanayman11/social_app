import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;
  final String uId;
  const CommentsScreen({Key? key,required this.postId,required this.uId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getComments(postId);
        return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var textCont = TextEditingController();
              var now = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());

              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Comments',
                      style: GoogleFonts.actor(),
                    ),
                  ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                          itemBuilder: (context,index){
                        if(postId==SocialCubit.get(context).comment[index].postId){
                        return commentItem(SocialCubit.get(context).comment[index], context,postId);}
                        else{
                          return SizedBox();
                        }
                      },
                       itemCount:SocialCubit.get(context).comment.length),
                    ),
                    if (SocialCubit.get(context).commentImage != null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                        SocialCubit.get(context).commentImage!)),
                              )),
                          FloatingActionButton(
                            heroTag: 'closeCommentImage',
                            onPressed: () {
                              SocialCubit.get(context).closeCommentImage();
                            },
                            child: const Icon(Icons.close),
                            mini: true,
                          )
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0,right: 5,left: 5,top: 5),
                      child: Card(
                        color:CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                        clipBehavior:Clip.antiAliasWithSaveLayer ,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  width: 330,
                                  child: TextFormField(
                                    controller: textCont,
                                    style: GoogleFonts.actor(
                                      color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 100,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.actor(
                                          color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                                        ),
                                        hintText: 'Type your comment ...'),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context).getCommentImage();
                                    },
                                    icon: Icon(
                                      Icons.image,
                                      color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                                    ))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                  color: Colors.blue,
                                  child: IconButton(
                                      onPressed: () {
                                        if (SocialCubit.get(context)
                                            .commentImage ==
                                            null) {
                                          if(textCont.text.isNotEmpty){
                                            SocialCubit.get(context).commentPost(postId: postId, text: textCont.text, dateTime: now);
                                            if(uId!=SocialCubit.get(context).userModel!.uId){
                                              SocialCubit.get(context).createNotification(id:uId, text: 'commented on your post', dateTime: now,postId: postId);
                                              FirebaseFirestore.instance.collection('users').doc(uId).update({'notification':true}).then((value){}).catchError((error){});
                                            }
                                          }}
                                        else {
                                          SocialCubit.get(context)
                                              .uploadCommentImage(postId: postId, dateTime: now, text: textCont.text);
                                          if(uId!=SocialCubit.get(context).userModel!.uId){
                                            SocialCubit.get(context).createNotification(id:uId, text: 'commented on your post', dateTime: now,postId: postId);
                                            FirebaseFirestore.instance.collection('users').doc(uId).update({'notification':true}).then((value){}).catchError((error){});
                                          }
                                          SocialCubit.get(context)
                                              .closeCommentImage();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                      ))),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

              );
            });
      }
    );
  }
}
Widget commentItem(CommentModel? model,context,String postId)=>Padding(
  padding: const EdgeInsets.only(top: 5,right: 10,left: 10,bottom: 5),
  child:   Container(
    decoration: BoxDecoration(
      color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
      borderRadius: BorderRadius.circular(20)
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
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
              if(model.uId==SocialCubit.get(context).userModel!.uId)
                IconButton(
                    onPressed: () {
                  SocialCubit.get(context).deleteComment(commentId: model.commentId, postId: postId);
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      size: 20,
                      color: Colors.grey,
                    ))
            ],
          ),
          SizedBox(height: 5,),
          if (model.text != "")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
              '${model.text}',
              style: GoogleFonts.actor(
                  color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                  fontSize: 14,
                  height: 1.5),
          ),
            ),
          if (model.text != "")
            SizedBox(height: 10,),
          if (model.commentImage != null)
            InkWell(
              child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image(
                    image: NetworkImage('${model.commentImage}'),
                    width: 300,
                    height: 150,
                    fit: BoxFit.cover,
                  )),
              onTap: () {
                showImageViewer(context,
                    Image.network('${model.commentImage}').image,
                    onViewerDismissed: () {});
              },
            ),



        ],
      ),
    ),
  ),
);
