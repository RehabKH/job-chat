class MessageModel {
  String? messageID;
  String? message;
  String? time;
  String? sendBy;

  MessageModel(this.messageID,this.message, this.sendBy, this.time);

  
  MessageModel.fromJson(Map<String, dynamic> json) {
    messageID = json["messageID"];
    message = json["message"];
    time = json["time"];
    sendBy = json["sendBy"];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["messageID"] = messageID;
    data["message"] = message;
    data['time'] = time;
    data['sendBy'] = sendBy;
    return data;
  }
}
