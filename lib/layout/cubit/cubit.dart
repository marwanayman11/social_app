import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats.dart';
import 'package:social_app/modules/newsfeed/newsfeed.dart';
import 'package:social_app/modules/search/search.dart';
import 'package:social_app/modules/settings/settings.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:translator/translator.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
  bool theme=false;
  void changeTheme(){
    theme=!CacheHelper.getData(key: 'theme');
    CacheHelper.saveData(key: 'theme', value: theme).then((value){
      emit(ChangeThemeState());
    });

  }
  UserModel? userModel;
  UserModel? userModel1;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .snapshots()
        .listen((event) {
      userModel = UserModel.fromJson(event.data());
      emit(SocialGetUserSuccessState());
    });
  }
  void getUser(String id) {
    emit(SocialGetUser1LoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      userModel1 = UserModel.fromJson(event.data());
      emit(SocialGetUser1SuccessState());
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    NewsFeedScreen(),
    SearchScreen(),
    ChatsScreen(),
    SettingsScreen()
  ];
  List titles = ['Home','Search', 'Chats', 'Settings'];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(SocialChangeBottomNavState());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImageSuccessState());
    } else {
      emit(SocialProfileImageErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImageSuccessState());
    } else {
      emit(SocialCoverImageErrorState());
    }
  }

  String profileImageUrl = '';

  void uploadProfileImage(
      {required String name, required String bio, required String phone}) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone, profile: value);
        profileImage = null;
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  String coverImageUrl = '';
  void uploadCoverImage(
      {required String name, required String bio, required String phone}) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone, cover: value);
        coverImage = null;
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser(
      {required String name,
      required String bio,
      required String phone,
      String? profile,
      String? cover}) {
    emit(SocialUpdateUserLoadingState());
    UserModel model = UserModel(
        phone: phone,
        name: name,
        bio: bio,
        uId: userModel!.uId,
        cover: cover ?? userModel!.cover,
        image: profile ?? userModel!.image,
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState(error.toString()));
    });
  }

  void followUser(UserModel model) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .collection('followers')
        .doc(userModel!.uId)
        .set({'follower': true}).then((value) {
      emit(SocialFollowUserSuccessState());
    }).catchError((error) {
      emit(SocialFollowUserErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('following')
        .doc(model.uId)
        .set({'following': true}).then((value) {
      emit(SocialFollowUserSuccessState());
    }).catchError((error) {
      emit(SocialFollowUserErrorState());
    });
  }

  void unFollowUser(UserModel model) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .collection('followers')
        .doc(userModel!.uId)
        .delete()
        .then((value) {
      emit(SocialUnFollowUserSuccessState());
    }).catchError((error) {
      emit(SocialUnFollowUserErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('following')
        .doc(model.uId)
        .delete()
        .then((value) {
      emit(SocialUnFollowUserSuccessState());
    }).catchError((error) {
      emit(SocialUnFollowUserErrorState());
    });
  }

  void getFollowers() {
    List l = [];
    List lf = [];
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      event.docs.forEach((element) {
        element.reference.collection('followers').snapshots().listen((value) {
          l = [];
          value.docs.forEach((e) {
            l.add(e.id);
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'followersCount': value.docs.length, 'followers': l})
              .then((value) {})
              .catchError((error) {});
        });
        element.reference.collection('following').snapshots().listen((value) {
          lf = [];
          value.docs.forEach((e) {
            lf.add(e.id);
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'followingCount': value.docs.length, 'following': lf})
              .then((value) {})
              .catchError((error) {});
        });
      });

      emit(SocialGetFollowersSuccessState());
    });
  }

  List<UserModel> followers = [];
  List<UserModel> following = [];
  void getFollowersProfiles() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      followers = [];
      event.docs.forEach((element) {
        if (userModel!.followers!.contains(element.id)) {
          followers.add(UserModel.fromJson(element.data()));
        }
      });
      emit(SocialGetFollowersProfilesSuccessState());
    });
  }

  void getFollowingProfiles() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      following = [];
      event.docs.forEach((element) {
        if (userModel!.following!.contains(element.id)) {
          following.add(UserModel.fromJson(element.data()));
        }
      });
      emit(SocialGetFollowingProfilesSuccessState());
    });
  }

  File? postImage;
  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImageSuccessState());
    } else {
      emit(SocialPostImageErrorState());
    }
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  PostModel? postModel;
  Future<void> createPost(
      {required String dateTime, required String text, String? postImage}) async {
    final translator = GoogleTranslator();
    Translation translation = await translator.translate(text);
    postModel = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage,
      isLiked: [],
      likesCount: 0,
      commentsCount: 0,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id).update({'postId':value.id,
        'lang':translation.sourceLanguage.code,
          })
          .then((value) {}).catchError((error){});
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  void closeImage() {
    postImage = null;
    emit(SocialCloseImageState());
  }

  List<PostModel> posts = [];
  List<CommentModel> comment = [];
  List<int> comments = [];
  PostModel? model;
  void getPosts() {
    emit(SocialGetPostsLoadingState());
    List l = [];
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      posts = [];
      for (var element in event.docs) {
        if (userModel!.following!.contains(element.data()['uId'])) {
          posts.add(PostModel.fromJson(element.data()));
          element.reference.collection('likes').snapshots().listen((value) {
            l = [];
            value.docs.forEach((e) {
              l.add(e.id);
            });
            FirebaseFirestore.instance
                .collection('posts')
                .doc(element.id)
                .update({'likesCount': value.docs.length, 'isLiked': l})
                .then((value) {})
                .catchError((error) {});
          });
          element.reference.collection('comments').snapshots().listen((value) {
            FirebaseFirestore.instance
                .collection('posts')
                .doc(element.id)
                .update({'commentsCount': value.docs.length})
                .then((value) {})
                .catchError((error) {});
          });
        }
      }
      emit(SocialGetPostsSuccessState());
    });
  }
  void getPost(String postId) {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots()
        .listen((event) {
      model=PostModel.fromJson(event.data());
      emit(SocialGetPostSuccessState());
    });
  }

  List profilePosts = [];
  void getProfilePosts() {
    emit(SocialGetProfilePostsLoadingState());
    List l = [];
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      profilePosts = [];
      for (var element in event.docs) {
        if (element.data()['uId'] == userModel!.uId) {
          profilePosts.add(PostModel.fromJson(element.data()));
          element.reference.collection('likes').snapshots().listen((value) {
            l = [];
            value.docs.forEach((e) {
              l.add(e.id);
            });
            FirebaseFirestore.instance
                .collection('posts')
                .doc(element.id)
                .update({'likesCount': value.docs.length, 'isLiked': l})
                .then((value) {})
                .catchError((error) {});
          });
          element.reference.collection('comments').snapshots().listen((value) {
            FirebaseFirestore.instance
                .collection('posts')
                .doc(element.id)
                .update({'commentsCount': value.docs.length})
                .then((value) {})
                .catchError((error) {});
          });
        }
      }
      emit(SocialGetProfilePostsSuccessState());
    });
  }

  List otherPosts = [];
  void getOtherPosts(UserModel? model) {
    emit(SocialGetOtherPostsLoadingState());
    List l = [];
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      otherPosts = [];
      for (var element in event.docs) {
        if (element.data()['uId'] == model!.uId) {
          otherPosts.add(PostModel.fromJson(element.data()));
          element.reference.collection('likes').snapshots().listen((value) {
            l = [];
            value.docs.forEach((e) {
              l.add(e.id);
            });
            FirebaseFirestore.instance
                .collection('posts')
                .doc(element.id)
                .update({'likesCount': value.docs.length, 'isLiked': l})
                .then((value) {})
                .catchError((error) {});
          });
          element.reference.collection('comments').snapshots().listen((value) {
            FirebaseFirestore.instance
                .collection('posts')
                .doc(element.id)
                .update({'commentsCount': value.docs.length})
                .then((value) {})
                .catchError((error) {});
          });
        }
      }
      emit(SocialGetOtherPostsSuccessState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }

  void unLikePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .delete()
        .then((value) {
      emit(SocialUnLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialUnLikePostsErrorState(error.toString()));
    });
  }

  void removePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(SocialDeletePostSuccessState());
    }).catchError((error) {
      emit(SocialDeletePostErrorState(error.toString()));
    });
  }

  CommentModel? commentModel;
  File? commentImage;

  Future getCommentImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(SocialCommentImageSuccessState());
    } else {
      emit(SocialCommentImageErrorState());
    }
  }

  void uploadCommentImage({
    required String postId,
    required String dateTime,
    required String text,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('comments/${Uri.file(commentImage!.path).pathSegments.last}')
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentPost(
            postId: postId,
            text: text,
            dateTime: dateTime,
            commentImage: value);
      }).catchError((error) {
        emit(SocialCommentPostsErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialCommentPostsErrorState(error.toString()));
    });
  }

  void closeCommentImage() {
    commentImage = null;
    emit(SocialCloseCommentImageState());
  }

  void commentPost(
      {String? commentImage,
      required String postId,
      required String text,
      required String dateTime}) {
    commentModel = CommentModel(
        text: text,
        postId: postId,
        image: userModel!.image,
        uId: userModel!.uId,
        name: userModel!.name,
        dateTime: dateTime,
        commentImage: commentImage);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel!.toMap())
        .then((value) {
      emit(SocialCommentPostsSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostsErrorState(error.toString()));
    });
  }

  void getComments(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comment = [];
      event.docs.forEach((element) {
        comment.add(CommentModel.fromJson(element.data()));
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(element.id)
            .update({'commentId': element.id})
            .then((value) => {})
            .catchError((error) {});
        emit(SocialGetCommentsSuccessState());
      });
    });
  }

  void deleteComment({required String? commentId, required String postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then((value) {
      emit(SocialDeleteCommentsSuccessState());
    }).catchError((error) {
      emit(SocialDeleteCommentsErrorState(error.toString()));
    });
  }

  List<UserModel> users = [];
  List<UserModel> search = [];
  List<UserModel> ls = [];

  void getUsers() {
    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      users = [];
      for (var element in event.docs) {
        if (element.data()['followers'].contains(userModel!.uId) &&
            userModel!.followers!.contains(element.id)) {
          users.add(UserModel.fromJson(element.data()));
        }
        emit(SocialGetAllUsersSuccessState());
      }
    });
  }

  void searchUsers(String value) {
    emit(SocialSearchUsersLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      search = [];
      for (var element in event.docs) {
        if (element.id != userModel!.uId) {
          if (element.data()['name'].contains(value)) {
            search.add(UserModel.fromJson(element.data()));
          }
        }
        emit(SocialSearchUsersSuccessState());
      }
    });
  }

  void getLovers(String postId) {
    emit(SocialGetLoversLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots()
          .listen((value) {
        ls = [];
        value.data()!['isLiked'].forEach((e) {
          event.docs.forEach((element) {
            if (e == element.id) {
              ls.add(UserModel.fromJson(element.data()));
            }
          });
        });
      });

      emit(SocialGetLoversSuccessState());
    });
  }

  File? messageImage;

  Future getMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(SocialMessageImageSuccessState());
    } else {
      emit(SocialMessageImageErrorState());
    }
  }

  void uploadMessageImage({
    required String? receiverId,
    required String dateTime,
    required String text,
    required String? fcm,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            receiverId: receiverId,
            text: text,
            dateTime: dateTime,
            messageImage: value,
            fcm: fcm);
      }).catchError((error) {
        emit(SocialSendMessageErrorState());
      });
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  void closeMessageImage() {
    messageImage = null;
    emit(SocialCloseMessageImageState());
  }

  Future<void> sendMessage(
      {required String? receiverId,
      required String text,
      required String dateTime,
      required String? fcm,
      String? messageImage}) async {
    MessageModel model = MessageModel(
        dateTime: dateTime,
        text: text,
        receiverId: receiverId,
        senderId: userModel!.uId,
        senderName: userModel!.name,
        messageImage: messageImage);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {

      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {

      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({required String? receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessageSuccessState());
    });
  }

  NotificationModel? notificationModel;
  void createNotification(
      {required String id,
      required String text,
      required String dateTime,
        String? postId,
      }) {
    notificationModel = NotificationModel(
        senderId: userModel!.uId,
        receiverId: id,
        text: text,
        dateTime: dateTime,
        senderName: userModel!.name,
      senderImage: userModel!.image,
       postId: postId
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('notifications')
        .add(notificationModel!.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('notifications')
          .doc(value.id).update({'notificationId':value.id})
          .then((value) {}).catchError((error){});
      emit(SocialCreateNotificationSuccessState());
    }).catchError((error) {
      emit(SocialCreateNotificationErrorState(error.toString()));
    });
  }

  List<NotificationModel> notifications = [];
  void getNotifications() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('notifications')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      notifications = [];
      event.docs.forEach((element) {
        notifications.add(NotificationModel.fromJson(element.data()));
      });
      emit(SocialGetNotificationsSuccessState());
    });
  }

 
}
