class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? postImage;
  String? postId;
  String? text;
  String? lang;
  List? isLiked;
  int? likesCount;
  int? commentsCount;
  PostModel(
      {this.postImage,
      this.name,
      this.dateTime,
      this.uId,
      this.image,
      this.text,
      this.isLiked,
      this.likesCount,
      this.commentsCount,
      this.postId,
      this.lang});
  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    dateTime = json['dateTime'];
    postImage = json['postImage'];
    postId = json['postId'];
    uId = json['uId'];
    image = json['image'];
    text = json['text'];
    isLiked = json['isLiked'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
    lang=json['lang'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateTime': dateTime,
      'postImage': postImage,
      'postId': postId,
      'uId': uId,
      'image': image,
      'text': text,
      'isLiked': isLiked,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'lang':lang
    };
  }
}
