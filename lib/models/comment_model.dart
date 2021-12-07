class CommentModel{
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postId;
  String? commentId;
  String? commentImage;
  CommentModel({this.name,this.dateTime,this.uId,this.image,this.text,this.postId,this.commentId,this.commentImage});
  CommentModel.fromJson(Map<String,dynamic>?json){
    name =json!['name'];
    dateTime =json['dateTime'];
    uId =json['uId'];
    image =json['image'];
    text =json['text'];
    postId =json['postId'];
    commentId =json['commentId'];
    commentImage =json['commentImage'];

  }
  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'dateTime':dateTime,
      'uId':uId,
      'image': image,
      'text': text,
      'postId':postId,
      'commentId':commentId,
      'commentImage':commentImage
    };
  }
}