import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/profile/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var searchCont = TextEditingController();
          return Scaffold(
              body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                    color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.grey[200],
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Form(
                      child: TextFormField(
                        onFieldSubmitted: (value){
                          SocialCubit.get(context).searchUsers(value);

                        },
                        style: GoogleFonts.actor(
                          color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                        ),
                        controller: searchCont,
                        keyboardType: TextInputType.name,
                        decoration:  InputDecoration(
                            prefixIcon: Icon(Icons.search,color:CacheHelper.getData(key: 'theme')?Colors.white:Colors.black ,),
                            border: InputBorder.none,
                            labelText: 'Search',
                          labelStyle: GoogleFonts.actor(
                            color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black
                          ),
                        ),
                      ),
                    )),
              ),
              Expanded(
                child:SocialCubit.get(context).search.isNotEmpty? ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: SocialCubit.get(context).search.length,
                  itemBuilder: (context, index) =>
                      searchItem(SocialCubit.get(context).search[index], context),
                  separatorBuilder: (context, index) => Container(
                      width: double.infinity, height: 2, color: Colors.grey[200]),
                ): Center(
                  child: Icon(Icons.search,color: Colors.blue,size: 150,

                  ),
                ),
              )
            ],
          ));
        });
  }
}

Widget searchItem(UserModel? model, context) => InkWell(
      onTap: () {
        pushTo(context, ProfileScreen(id: model!.uId!));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 5,
          color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
