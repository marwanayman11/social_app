import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class NewPost extends StatelessWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var textCont = TextEditingController();

          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Create post',
                  style: GoogleFonts.actor(),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: defaultButton(
                        text: 'Post',
                        function: () {
                          if (SocialCubit.get(context).postImage == null) {
                            SocialCubit.get(context).createPost(
                                dateTime: DateFormat('dd-MM-yyyy hh:mm:ss a')
                                    .format(DateTime.now()),
                                text: textCont.text);
                          } else {
                            SocialCubit.get(context).uploadPostImage(
                                dateTime: DateFormat('dd-MM-yyyy hh:mm:ss a')
                                    .format(DateTime.now()),
                                text: textCont.text);
                          }
                          Navigator.pop(context);
                          SocialCubit.get(context).postImage = null;
                        },
                        width: 100),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${SocialCubit.get(context).userModel!.name}',
                        style: GoogleFonts.actor(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
                            height: 1),
                      ),
                    ]),
                    Expanded(
                      child: TextFormField(
                        maxLines: 100,
                        keyboardType: TextInputType.multiline,
                        controller: textCont,
                        style: GoogleFonts.actor(
                            color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                        ),
                        decoration:  InputDecoration(
                          hintStyle: GoogleFonts.actor(
                            color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                          ),
                            hintText: 'What\'s on your mind ?',
                            border: InputBorder.none),
                      ),
                    ),
                    if (SocialCubit.get(context).postImage != null)
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
                                        SocialCubit.get(context).postImage!)),
                              )),
                          FloatingActionButton(
                            heroTag: 4,
                            onPressed: () {
                              SocialCubit.get(context).closeImage();
                            },
                            child: const Icon(Icons.close),
                            mini: true,
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Add photo',
                              style: GoogleFonts.actor(),
                            )
                          ],
                        ))
                  ],
                ),
              ));
        });
  }
}
