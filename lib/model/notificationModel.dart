class NotificationModel {
  String? notificationId;
  String? userID;
  String? title;
  String? body;
  bool? isOpened;

  NotificationModel(this.notificationId, this.userID, this.title, this.body,this.isOpened);

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json["notificationId"];
    userID = json["userID"];
    title = json["title"];
    body = json["body"];
    isOpened = json["isOpened"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["notificationId"] = notificationId;
    data["userID"] = userID;
    data['title'] = title;
    data['body'] = body;
    data['isOpened'] = isOpened;
    return data;
  }
}
