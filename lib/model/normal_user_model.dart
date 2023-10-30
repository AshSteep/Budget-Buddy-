class UserModel {
  final String username;
  final String userType;
  UserModel({
    required this.username,
    required this.userType
  });
  toJson() {
    return {"username": username,"userType":userType};
  }
}
