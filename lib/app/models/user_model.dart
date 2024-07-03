
import 'parents/model.dart';

class UserModel extends Model {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? gender;
  var phoneNumber;
  String? birthdate;
  String? zoneId;
  int? userId;
  String? avatarUrl;
  String? authToken;
  String? companyName;
  static bool? auth;
  List? sectors;

  UserModel({this.userId,this.firstName, this.email, this.authToken, this.password, this.phoneNumber, this.avatarUrl, this.birthdate, this.companyName, this.gender,
  this.lastName, this.zoneId, this. sectors});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = stringFromJson(json, 'first_name');
    lastName = stringFromJson(json, 'last_name');
    email = stringFromJson(json, 'email');
    phoneNumber = stringFromJson(json, 'phone');
    gender = stringFromJson(json, 'gender');
    userId = intFromJson(json, 'id');
    birthdate = stringFromJson(json, 'date_of_birth');
    authToken = stringFromJson(json, 'token');
    zoneId = stringFromJson(json, 'zone_id');
    avatarUrl = stringFromJson(json, 'avatar');



    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phoneNumber;
    data['gender'] = gender;
    data['zone_id'] = zoneId;
    data['date_of_birth'] = birthdate;
    data['password'] = password;
    data['token'] = authToken;
    data['id'] = userId;
    //data['sectors'] = sectors;


    return data;
  }




}
