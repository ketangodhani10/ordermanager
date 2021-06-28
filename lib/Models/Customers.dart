class Customers {
  String? documentID;
  String? companyName;
  String? orderCode;
  String? customerName;
  String? orderDetails;
  String? phoneNumber;
  String? address;
  String? city;
  String? stateCountry;
  String? postalCode;
  int?
      status; //0 = Pending to confirm order, 1 = Order confirm but awaiting to payment, 2 = Payment and order confirm, 3 = Pending to Deliver, 4 = Delivered
  String? createdBy; //added by which user
  String? createdOn;
  String? modifiedBy; //modified by which user
  String? modifiedOn;

  Customers(
      {this.documentID,
      this.companyName,
      this.orderCode,
      this.customerName,
      this.orderDetails,
      this.phoneNumber,
      this.address,
      this.city,
      this.stateCountry,
      this.postalCode,
      this.status,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn});

  factory Customers.fromJson(Map<String, dynamic> data) => new Customers(
        documentID: data["documentID"],
        companyName: data["companyName"],
        orderCode: data["orderCode"],
        customerName: data["customerName"],
        orderDetails: data["orderDetails"],
        phoneNumber: data["phoneNumber"],
        address: data["address"],
        city: data["city"],
        stateCountry: data["stateCountry"],
        postalCode: data["postalCode"],
        status: data["status"],
        createdBy: data["createdBy"],
        createdOn: data["createdOn"],
        modifiedBy: data["modifiedBy"],
        modifiedOn: data["modifiedOn"],
      );

  Map<String, dynamic> toJson() => {
        "documentID": documentID,
        "companyName": companyName,
        "orderCode": orderCode,
        "customerName": customerName,
        "orderDetails": orderDetails,
        "phoneNumber": phoneNumber,
        "address": address,
        "city": city,
        "stateCountry": stateCountry,
        "postalCode": postalCode,
        "status": status,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
      };
}
