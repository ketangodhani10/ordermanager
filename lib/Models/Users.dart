class Users {
  String? documentID;
  String? fullName;
  String? userName;
  String? password;
  String? role;
  String? defaultCompanyName;
  bool? isActive;

  Users(
      {this.documentID,
      this.fullName,
      this.userName,
      this.password,
      this.role,
      this.defaultCompanyName,
      this.isActive});

  factory Users.fromJson(Map<String, dynamic> data) => new Users(
      documentID: data["documentID"],
      fullName: data["fullName"],
      userName: data["userName"],
      password: data["password"],
      role: data["role"],
      defaultCompanyName: data["defaultCompanyName"],
      isActive: data["isActive"]);

  Map<String, dynamic> toJson() => {
        "documentID": documentID,
        "fullName": fullName,
        "userName": userName,
        "password": password,
        "role": role,
        "defaultCompanyName": defaultCompanyName,
        "isActive": isActive,
      };
}
