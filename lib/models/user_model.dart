class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  String? fcm;
  int? followersCount;
  int? followingCount;
  List? followers;
  List? following;
  bool? isEmailVerified;
  bool? notification;
  UserModel(
      {this.email,
      this.name,
      this.phone,
      this.uId,
      this.isEmailVerified,
      this.image,
      this.bio,
      this.cover,
      this.fcm,
      this.followers,
      this.following,
      this.followingCount,
      this.followersCount,
        this.notification
      });
  UserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
    fcm = json['fcm'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    followers = json['followers'];
    following = json['following'];
    notification = json['notification'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
      'fcm': fcm,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'followers': followers,
      'following': following,
      'notification':notification

    };
  }
}
