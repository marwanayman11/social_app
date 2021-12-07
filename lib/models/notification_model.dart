class NotificationModel{
  String? receiverId;
  String? senderId;
  String? dateTime;
  String? text;
  String? senderName;
  String? senderImage;
  String? notificationId;
  String? postId;
  NotificationModel({this.receiverId,this.senderId,this.dateTime,this.text,this.senderName,this.senderImage,this.notificationId,this.postId});
  NotificationModel.fromJson(Map<String,dynamic>?json){
    receiverId =json!['receiverId'];
    dateTime =json['dateTime'];
    senderId =json['senderId'];
    text =json['text'];
    senderName=json['senderName'];
    senderImage=json['senderImage'];
    notificationId=json['notificationId'];
    postId=json['postId'];

  }
  Map<String,dynamic> toMap(){
    return{
      'receiverId':receiverId,
      'dateTime':dateTime,
      'senderId':senderId,
      'text': text,
      'senderImage':senderImage,
      'senderName':senderName,
      'notificationId':notificationId,
      'postId':postId
    };
  }
}