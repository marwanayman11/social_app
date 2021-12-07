import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/profile/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoversScreen extends StatelessWidget {
  final String? postId;
  LoversScreen({Key? key,this.postId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          SocialCubit.get(context).getLovers(postId!);
          return BlocConsumer<SocialCubit, SocialStates>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Likes',style: GoogleFonts.actor(),),
                  ),
                  body:SocialCubit.get(context).ls.isNotEmpty? ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: SocialCubit.get(context).ls.length,
                    itemBuilder: (context, index) => loverItem(SocialCubit.get(context).ls[index],context),
                    separatorBuilder: (context, index) => Container(
                        width: double.infinity, height: 2, color: Colors.grey),
                  ): Center(child:  Icon(Icons.favorite,color: Colors.blue,size: 150,

                  ),)
                );
              },
              listener: (context, state) {});
        }
    );
  }


}

Widget loverItem(UserModel? model,context) =>
    InkWell(
      onTap: (){
        if(model!.uId!=SocialCubit.get(context).userModel!.uId)
          pushTo(context, ProfileScreen(id: model.uId!,));
      },
      child:   Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 5,
          color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:   Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  NetworkImage('${model!.image}'),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );


