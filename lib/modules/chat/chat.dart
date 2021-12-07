import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/profile/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class ChatDetails extends StatelessWidget {
  final UserModel? model;
  const ChatDetails({Key? key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(receiverId: model!.uId,);
      return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            var messageCont = TextEditingController();
            RefreshController _refreshController =
            RefreshController(initialRefresh: false);

            void _onRefresh() async{
              // monitor network fetch
              await Future.delayed(Duration(milliseconds: 1000));
              // if failed,use refreshFailed()
              SocialCubit.get(context).getMessages(receiverId: model!.uId,);
              _refreshController.refreshCompleted();
            }

            void _onLoading() async{
              // monitor network fetch
              await Future.delayed(Duration(milliseconds: 1000));
              // if failed,use loadFailed(),if no data return,use LoadNodata()
              _refreshController.loadComplete();
            }
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: InkWell(
                  onTap: () {
                    pushTo(
                        context,
                        ProfileScreen(
                          id: model!.uId!,
                        ));
                  },
                  child: Row(
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
                            '${model!.name}',
                            style: GoogleFonts.actor(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                                height: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              body: SmartRefresher(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];
                            if (SocialCubit.get(context).userModel!.uId ==
                                message.senderId) {
                              return myMessage(message);
                            } else {
                              return otherMessage(message, model);
                            }
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: SocialCubit.get(context).messages.length),
                    ),
                    if (SocialCubit.get(context).messageImage != null)
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
                                        SocialCubit.get(context).messageImage!)),
                              )),
                          FloatingActionButton(
                            heroTag: 'close image',
                            onPressed: () {
                              SocialCubit.get(context).closeMessageImage();
                            },
                            child: const Icon(Icons.close),
                            mini: true,
                          )
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0,right: 5,left: 5,top: 5),
                      child: Card(
                        color:CacheHelper.getData(key: 'theme')?Colors.grey[900]: Colors.grey[200],
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
                                    style: GoogleFonts.actor(
                                      color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                                    ),
                                    controller: messageCont,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 100,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.actor(
                                          color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                                        ),
                                        hintText: 'Type your message ...'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context).getMessageImage();
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
                                                .messageImage ==
                                            null) {
                                         if(messageCont.text.isNotEmpty){
                                          SocialCubit.get(context).sendMessage(
                                            fcm: model!.fcm,
                                              receiverId: model!.uId,
                                              text: messageCont.text,
                                              dateTime:DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now())
                                          );
                                         }}else {
                                          SocialCubit.get(context)
                                              .uploadMessageImage(
                                                   fcm: model!.fcm,
                                                  receiverId: model!.uId,
                                                  dateTime:DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now())
                                              ,
                                                  text: 'Sent a photo');
                                          SocialCubit.get(context)
                                              .closeMessageImage();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ))),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {});
    });
  }
}
Widget otherMessage(MessageModel? model, UserModel? model1) =>
    Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage('${model1!.image}'),
                ),
                SizedBox(
                  width: 5,
                ),
                model!.messageImage != null
                    ? InkWell(
                  child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image(
                        image: NetworkImage('${model.messageImage}'),
                        height: 300,
                        width: 200,
                        fit: BoxFit.cover,
                      )),
                  onTap: () {
                    showImageViewer(context,
                        Image.network('${model.messageImage}').image,
                        onViewerDismissed: () {});
                  },
                )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                               '${model.text}',
                                style: GoogleFonts.actor(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                            if (model.messageImage != null)
                              Image(
                                  image: NetworkImage('${model.messageImage}'),
                                  height: 200,
                                  width: 200),
                          ],
                        ),
                      ),
                const Spacer()
              ],
            ),
            Text(
              '${model.dateTime}',
              style: GoogleFonts.actor(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    });

Widget myMessage(MessageModel? model) => Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Spacer(),
                model!.messageImage != null
                    ? InkWell(
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Image(
                              image: NetworkImage('${model.messageImage}'),
                              height: 300,
                              width: 200,
                              fit: BoxFit.cover,
                            )),
                        onTap: () {
                          showImageViewer(context,
                              Image.network('${model.messageImage}').image,
                              onViewerDismissed: () {});
                        },
                      )
                    : Container(
                  decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '${model.text}',
                                style: GoogleFonts.actor(

                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel!.image}'),
                ),
              ],
            ),
            Text(
              '${model.dateTime}',
              style: GoogleFonts.actor(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    });
