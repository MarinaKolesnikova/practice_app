import 'dart:convert';

ApiUserResult apiUserResultFromJson(String str) => ApiUserResult.fromJson(json.decode(str));

String apiUserResultToJson(ApiUserResult data) => json.encode(data.toJson());

class ApiUserResult {
  ApiUserResult({required this.success, required this.token});

  bool success;
  String token;

  factory ApiUserResult.fromJson(Map<String, dynamic> json) => ApiUserResult(
    success: json["success"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "token": token,
  };
}


