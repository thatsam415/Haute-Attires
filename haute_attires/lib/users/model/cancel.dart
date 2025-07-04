class Cancel {
  int cancel_id;
  int order_id;
  String cancel_by;
  String reason;

  Cancel(
    this.cancel_id,
    this.order_id,
    this.cancel_by,
    this.reason,
  );

  factory Cancel.fromJson(Map<String, dynamic> json) => Cancel (
    int.parse(json["cancel_id"]),
    int.parse(json["order_id"]),
    json["cancel_by"],
    json["reason"],
  );
}