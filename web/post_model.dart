import 'dart:convert';

List<PostModel> postModelFromMap(Iterable<MapEntry<String,String>> str) =>
    List<PostModel>.from(str.map((x) => PostModel.fromJson(json.decode(x.value))));

String postModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class PostModel {
  String name;
  String email;
  String type;
  String message;
  PostModel(
      {required this.name,
      required this.email,
      required this.type,
      required this.message});

  List<String> getElementsKeys() => [
        "name",
        "email",
        "type",
        "message",
        ]; 

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        name: json["name"],
        email: json["email"],
        type: json["type"],
        message: json["message"],
      );   

  Map<String, String> toJson() => {
        "name": name,
        "email": email,
        "type": type,
        "message": message,
      };
}
