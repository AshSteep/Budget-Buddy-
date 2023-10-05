class UserModel {
  final String username;
  UserModel({required this.username});
  toJson() {
    return {"username": username};
  }
}
