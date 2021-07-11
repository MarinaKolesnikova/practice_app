import 'dart:convert';

ApiVote apiVoteFromJson(String str) => ApiVote.fromJson(json.decode(str));
String apiVoteToJson(ApiVote data) => json.encode(data.toJson());

class ApiVote {
  int id;
  int product;
  CreatedBy createdBy;
  int rate;
  String text;
  DateTime created_at;

  ApiVote({
    required this.id,
    required this.product,
    required this.createdBy,
    required this.rate,
    required this.text,
    required this.created_at,
  });

  factory ApiVote.fromJson(Map<String, dynamic> json) => ApiVote(
    id: json["id"],
    product: json["product"],
    createdBy: CreatedBy.fromJson(json["created_by"]) as CreatedBy,
    rate: json["rate"],
    text: json["text"],
    created_at: DateTime.parse(json["created_at"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product,
    "created_by": createdBy.toJson(),
    "rate": rate,
    "text": text,
    "created_at":created_at.toString(),
  };
}

class CreatedBy {

  int id;
  String username;
  String first_name;
  String last_name;
  String email;

  CreatedBy({
    required this.id,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.email
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
        id: json["id"],
        username: json["username"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        email: json["email"]
  );}

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}