class Order {
  int? order_id;
  int? user_id;
  String? selectedItems;
  String? deliverySystem;
  String? paymentSystem;
  String? note;
  double? totalAmount;
  String? status;
  DateTime? dateTime;
  String? shipmentAddress;
  String? phoneNumber;

  Order({
    this.order_id,
    this.user_id,
    this.selectedItems,
    this.deliverySystem,
    this.paymentSystem,
    this.note,
    this.totalAmount,
    this.status,
    this.dateTime,
    this.shipmentAddress,
    this.phoneNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json)=> Order(
    order_id: int.parse(json["order_id"]),
    user_id: int.parse(json["user_id"]),
    selectedItems: json["selectedItems"],
    deliverySystem: json["deliverySystem"],
    paymentSystem: json["paymentSystem"],
    note: json["note"],
    totalAmount: double.parse(json["totalAmount"]),
    status: json["status"],
    dateTime: DateTime.parse(json["dateTime"]),
    shipmentAddress: json["shipmentAddress"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() {
    return {
      "order_id": order_id?.toString(),
      "user_id": user_id?.toString(),
      "selectedItems": selectedItems,
      "deliverySystem": deliverySystem,
      "paymentSystem": paymentSystem,
      "note": note,
      "totalAmount": totalAmount?.toStringAsFixed(2),
      "status": status,
      "shipmentAddress": shipmentAddress,
      "phoneNumber": phoneNumber,
    };
  }
}
