abstract class SocialStates{}
class SocialInitialState extends SocialStates{}
class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{
  final String error;
  SocialGetUserErrorState(this.error);
}
class SocialGetAllUsersLoadingState extends SocialStates{}
class SocialGetAllUsersSuccessState extends SocialStates{}
class SocialGetAllUsersErrorState extends SocialStates{
  final String error;
  SocialGetAllUsersErrorState(this.error);
}
class SocialChangeBottomNavState extends SocialStates{}
class SocialProfileImageSuccessState extends SocialStates{}
class SocialProfileImageErrorState extends SocialStates{}
class SocialCoverImageSuccessState extends SocialStates{}
class SocialCoverImageErrorState extends SocialStates{
}
class SocialUploadCoverImageErrorState extends SocialStates{}
class SocialUploadProfileImageErrorState extends SocialStates{
}
class SocialUpdateUserLoadingState extends SocialStates{

}
class SocialUpdateUserErrorState extends SocialStates{
  final String error;
  SocialUpdateUserErrorState(this.error);
}
class SocialCreatePostLoadingState extends SocialStates{}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{
  final String error;
  SocialCreatePostErrorState(this.error);
}
class SocialPostImageSuccessState extends SocialStates{}
class SocialPostImageErrorState extends SocialStates{}
class SocialCloseImageState extends SocialStates{}

class SocialGetPostsLoadingState extends SocialStates{}
class SocialGetPostsSuccessState extends SocialStates{}
class SocialGetPostsErrorState extends SocialStates{
  final String error;
  SocialGetPostsErrorState(this.error);
}
class SocialLikePostsSuccessState extends SocialStates{}
class SocialLikePostsErrorState extends SocialStates{
  final String error;
  SocialLikePostsErrorState(this.error);
}

class SocialUnLikePostsSuccessState extends SocialStates{}
class SocialUnLikePostsErrorState extends SocialStates{
  final String error;
  SocialUnLikePostsErrorState(this.error);
}
class SocialDeletePostSuccessState extends SocialStates{}
class SocialDeletePostErrorState extends SocialStates{
  final String error;
  SocialDeletePostErrorState(this.error);
}

class SocialCommentPostsSuccessState extends SocialStates{}
class SocialCommentPostsErrorState extends SocialStates{
  final String error;
  SocialCommentPostsErrorState(this.error);
}

class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{}
class SocialGetMessageSuccessState extends SocialStates{}
class SocialMessageImageSuccessState extends SocialStates{}
class SocialMessageImageErrorState extends SocialStates{}
class SocialCloseMessageImageState extends SocialStates{}

class SocialGetCommentsSuccessState extends SocialStates{}
class SocialDeleteCommentsSuccessState extends SocialStates{}
class SocialDeleteCommentsErrorState extends SocialStates{
  final String error;
  SocialDeleteCommentsErrorState(this.error);
}
class SocialSearchUsersLoadingState extends SocialStates{}
class SocialSearchUsersSuccessState extends SocialStates{}
class SocialGetProfilePostsLoadingState extends SocialStates{}
class SocialGetProfilePostsSuccessState extends SocialStates{}
class SocialGetOtherPostsLoadingState extends SocialStates{}
class SocialGetOtherPostsSuccessState extends SocialStates{}
class SocialGetLoversLoadingState extends SocialStates{}
class SocialGetLoversSuccessState extends SocialStates{}
class SocialCommentImageSuccessState extends SocialStates{}
class SocialCommentImageErrorState extends SocialStates{}
class SocialCloseCommentImageState extends SocialStates{}
class SocialFollowUserSuccessState extends SocialStates{}
class SocialFollowUserErrorState extends SocialStates{}
class SocialUnFollowUserSuccessState extends SocialStates{}
class SocialUnFollowUserErrorState extends SocialStates{}
class SocialGetFollowersSuccessState extends SocialStates{}
class SocialGetUserProfileSuccessState extends SocialStates{
}
class SocialGetFollowersProfilesSuccessState extends SocialStates{}
class SocialGetFollowingProfilesSuccessState extends SocialStates{}
class SocialPostLangSuccessState extends SocialStates{}

class SocialCreateNotificationSuccessState extends SocialStates{}
class SocialCreateNotificationErrorState extends SocialStates{
  final String error;
  SocialCreateNotificationErrorState(this.error);
}
class SocialGetNotificationsSuccessState extends SocialStates{}
class SocialGetPostLoadingState extends SocialStates{}
class SocialGetPostSuccessState extends SocialStates{}
class SocialGetUser1LoadingState extends SocialStates{}
class SocialGetUser1SuccessState extends SocialStates{}
class ChangeThemeState extends SocialStates{}





























