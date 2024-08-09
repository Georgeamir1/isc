class Usermodel1 {
  String? userName;
  String? userPassword;

  Usermodel1({this.userName, this.userPassword});

  // Factory method to create a Usermodel1 from JSON
  factory Usermodel1.fromJson(Map<String, dynamic> json) {
    return Usermodel1(
      userName: json['UserName'] as String?,
      userPassword: json['UserPassword'] as String?,
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'UserName': userName,
      'UserPassword': userPassword,
    };
  }

  // Method to convert a list of JSON maps to a list of User objects
  static List<Usermodel1> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Usermodel1.fromJson(json as Map<String, dynamic>)).toList();
  }
}
