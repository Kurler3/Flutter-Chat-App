import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PersonalizedUser {
  final String uid;
  final String? profilePic;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  late String? profilePicDownloadUrl;

  PersonalizedUser(
      {required this.uid,
      this.profilePic,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.phoneNumber});

  factory PersonalizedUser.fromJson(Map<String, dynamic> json) =>
      PersonalizedUser(
          uid: json['id'] as String,
          profilePic: json['profile_pic'] == null
              ? null
              : json['profile_pic'] as String,
          firstName: json['first_name'] as String,
          lastName: json['last_name'] as String,
          email: json['email'] as String,
          password: json['password'] as String,
          phoneNumber: json['phone_number'] as String);

  Map<String, dynamic> toJson() {
    return {
      "id": uid,
      "profile_pic": profilePic,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "phone_number": phoneNumber
    };
  }
}
