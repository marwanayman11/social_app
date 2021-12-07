import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat/chat.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
        return Builder(
          builder: (context) {
            SocialCubit.get(context).getUsers();
            return BlocConsumer<SocialCubit, SocialStates>(
                builder: (context, state) {
                  RefreshController _refreshController =
                  RefreshController(initialRefresh: false);

                  void _onRefresh() async{
                    // monitor network fetch
                    await Future.delayed(Duration(milliseconds: 1000));
                    // if failed,use refreshFailed()
                    SocialCubit.get(context).getUsers();
                    _refreshController.refreshCompleted();
                  }

                  void _onLoading() async{
                    // monitor network fetch
                    await Future.delayed(Duration(milliseconds: 1000));
                    // if failed,use loadFailed(),if no data return,use LoadNodata()

                    _refreshController.loadComplete();
                  }
                  if(SocialCubit.get(context).users.isEmpty){
                    return Center(child: Icon(Icons.chat,color: Colors.blue,size: 150,

                    ),);
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
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: SocialCubit.get(context).users.length,
                      itemBuilder: (context, index) => chatItem(SocialCubit.get(context).users[index],context),
                      separatorBuilder: (context, index) => Container(
                          width: double.infinity, height: 2, color: Colors.grey),
                    ),
                  );
                },
                listener: (context, state) {});
          }
        );
      }


}

Widget chatItem(UserModel? model,context) =>
    InkWell(
      onTap: (){
        pushTo(context, ChatDetails(model: model));
      },
      child:   Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 5,
          color:CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
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
                              color:CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
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


