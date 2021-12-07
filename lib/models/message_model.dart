class MessageModel{
  String? receiverId;
  String? senderId;
  String? dateTime;
  String? text;
  String? messageImage;
  String? senderName;
  MessageModel({this.receiverId,this.senderId,this.dateTime,this.text,this.messageImage,this.senderName});
  MessageModel.fromJson(Map<String,dynamic>?json){
    receiverId =json!['receiverId'];
    dateTime =json['dateTime'];
    senderId =json['senderId'];
    text =json['text'];
    messageImage =json['messageImage'];
    senderName=json['senderName'];
  }
  Map<String,dynamic> toMap(){
    return{
      'receiverId':receiverId,
      'dateTime':dateTime,
      'senderId':senderId,
      'text': text,
      'messageImage':messageImage,
      'senderName':senderName,
    };
  }
}