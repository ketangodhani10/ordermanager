class Companies {
  String? documentID;
  String? companyName;

  Companies({this.documentID, this.companyName});

  factory Companies.fromJson(Map<String, dynamic> data) => new Companies(
      documentID: data["documentID"], companyName: data["companyName"]);

  Map<String, dynamic> toJson() =>
      {"documentID": documentID, "companyName": companyName};
}
