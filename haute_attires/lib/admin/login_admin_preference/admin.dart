class Admin {
  int admin_id;
  String admin_name;
  String admin_email;
  String admin_password;

  Admin(
    this.admin_id,
    this.admin_name,
    this.admin_email,
    this.admin_password,
  );

  // Convert JSON to Admin object
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      int.parse(json["admin_id"]), // Ensure 'admin_id' is parsed as an integer
      json["admin_name"],
      json["admin_email"],
      json["admin_password"],
    );
  }

  // Convert Admin object to JSON
  Map<String, dynamic> toJson() => {
    'admin_id': admin_id.toString(), // Convert the int back to a string for storage
    'admin_name': admin_name,
    'admin_email': admin_email,
    'admin_password': admin_password,
  };
}
