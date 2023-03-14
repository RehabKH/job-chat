class UserModel {
  String? uid;
  String? token;
  String userName;
  String userEmail;
  String registerType;
  UserModel(this.userName, this.userEmail, this.registerType, {this.token,this.uid});

Map<String, dynamic> toMap(){
  final Map<String, dynamic> data = new Map<String, dynamic>();
    // data["uid"] = uid;
    data['token'] = token;
    data['name'] = userName;
    data['email'] = userEmail;
    data['register type'] = registerType;
    

    return data;
}

}
