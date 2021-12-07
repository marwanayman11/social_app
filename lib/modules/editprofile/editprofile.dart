import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = SocialCubit.get(context).userModel;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;
          var nameCont = TextEditingController();
          var bioCont = TextEditingController();
          var phoneCont = TextEditingController();
          nameCont.text=model!.name!;
          bioCont.text=model.bio!;
          phoneCont.text=model.phone!;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              heroTag: 1,
              onPressed: () {
                SocialCubit.get(context).updateUser(name: nameCont.text, bio: bioCont.text, phone: phoneCont.text);
              },
              child: const Icon(Icons.update),
            ),
            appBar: AppBar(
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  if(state is SocialUpdateUserLoadingState) const LinearProgressIndicator(),
                  SizedBox(
                    height: 240,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: coverImage == null
                                            ? NetworkImage('${model.cover}')
                                            : FileImage(coverImage)
                                                as ImageProvider),
                                  )),
                              FloatingActionButton(
                                heroTag: 2,
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                child: const Icon(Icons.camera_alt_outlined),
                                mini: true,
                              )
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 65,
                              child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileImage == null
                                      ? NetworkImage('${model.image}')
                                      : FileImage(profileImage)
                                          as ImageProvider),
                            ),
                            FloatingActionButton(
                              heroTag: 3,
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              child: const Icon(Icons.camera_alt_outlined),
                              mini: true,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                    const SizedBox(height: 10,),
                  Row(children: [
                    if(SocialCubit.get(context).profileImage!=null)
                    Expanded(
                      child: Column(
                        children: [
                          defaultButton(text: 'Update profile', function:(){
                            SocialCubit.get(context).uploadProfileImage(name: nameCont.text, bio: bioCont.text, phone: phoneCont.text);}),
                          if(state is SocialUpdateUserLoadingState)
                          const LinearProgressIndicator()
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    if(SocialCubit.get(context).coverImage!=null)
                      Expanded(
                        child: Column(
                          children: [
                            defaultButton(text: 'Update cover', function:(){
                              SocialCubit.get(context).uploadCoverImage(name: nameCont.text, bio: bioCont.text, phone: phoneCont.text);
                            }),
                            if(state is SocialUpdateUserLoadingState)
                              const LinearProgressIndicator()
                          ],
                        ),
                      ),
                  ],),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultForm(
                      controller: nameCont,
                      type: TextInputType.name,
                      label: 'Name',
                      prefix: Icons.person,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Name can\'t be empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultForm(
                      controller: bioCont,
                      type: TextInputType.text,
                      label: 'Bio',
                      prefix: Icons.info,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Bio can\'t be empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultForm(
                      controller: phoneCont,
                      type: TextInputType.phone,
                      label: 'phone',
                      prefix: Icons.phone,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Phone can\'t be empty';
                        }
                        return null;
                      }),
                ]),
              ),
            ),
          );
        });
  }
}
