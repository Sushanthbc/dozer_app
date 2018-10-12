part of dozer;

class AppUserInfo{

  int userId;
  String firstName;
  String lastName;
  String emailID;
  String phone;
  bool isAdmin;
  String aboutUser;
  String purpose;
  String town;

  AppUserInfo({
    this.userId,
    this.firstName,
    this.lastName,
    this.emailID,
    this.phone,
    this.isAdmin,
    this.aboutUser,
    this.purpose,
    this.town
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
        if (map['id'] != null) {
          map['id'] = userId;
        }
        map['first_name'] = firstName;
        map['last_name'] = lastName;
        map['email_id'] = emailID;
        map['phone'] = phone;
        map['town'] = town;
        map['about_user'] = aboutUser;
        map['purpose'] = purpose;
    return map;
  }

  AppUserInfo.fromMap(Map<String, dynamic> map) {
    this.userId = map['id'];
    this.firstName = map['first_name'];
    this.lastName = map['last_name'];
    this.emailID = map['email_id'];
    this.phone = map['phone'];
    this.town = map['town'];
    this.isAdmin = map['admin'];
    this.aboutUser = map['about_user'];
    this.purpose = map['purpose'];
  }

}