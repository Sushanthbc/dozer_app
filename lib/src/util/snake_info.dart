part of dozer;

class SnakeInfo {
  int id;
  String snakeLength;
  String snakeLengthUnit;
  String snakeWeight;
  String snakeWeightUnit;
  String snakeSex;
  String snakeColor;
  String snakeBehavior;
  String snakeCondition;
  String dividedSubCaudals;
  String undividedSubCaudals;

  String rescueDateTime;
  DateTime rescueDate;
  TimeOfDay rescueTime;

  String callerName;
  String callerPhone;
  String address;
  String pincode;
  String village;
  String latitude;
  String longitude;
  String elevation;
  String elevationUnit;

  String macroHabitat;
  String microHabitat;

  List<File> images;
  List<Map> imagesInfo;
  File image;


  SnakeInfo({
    this.snakeLength,
    this.snakeLengthUnit,
    this.snakeWeight,
    this.snakeWeightUnit,
    this.snakeSex,
    this.snakeColor,
    this.snakeBehavior,
    this.snakeCondition,
    this.dividedSubCaudals,
    this.undividedSubCaudals,
    this.callerName,
    this.callerPhone,
    this.address,
    this.pincode,
    this.macroHabitat,
    this.microHabitat,
    this.id,
    this.village,
    this.rescueDateTime,
    this.rescueDate,
    this.rescueTime,
    this.latitude,
    this.longitude,
    this.elevation,
    this.elevationUnit,
    this.image,
    this.images,
    this.imagesInfo
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['rescue_date_time'] = new DateTime(
      rescueDate.year, rescueDate.month, rescueDate.day, rescueTime.hour, rescueTime.minute
    ).toString();
    map['address'] = address;
    map['village'] = village;
    map['pincode'] = int.parse(pincode);
    map['country'] = "IN"; //YTI
    map['caller_name'] = callerName;
    map['caller_phone'] = callerPhone;
    map['snake_length'] = double.parse(snakeLength);
    map['snake_length_unit'] = snakeLengthUnit;
    map['snake_weight'] = double.parse(snakeWeight);
    map['snake_weight_unit'] = snakeWeightUnit;
    map['snake_sex'] = snakeSex;
    map['snake_color'] = snakeColor;
    map['snake_behavior'] = snakeBehavior;
    map['snake_micro_habitat'] = microHabitat;
    map['snake_macro_habitat'] = macroHabitat;
    map['snake_condition'] = snakeCondition;
    map['subcaudals'] = "D:" + dividedSubCaudals + ";" + "U:" + undividedSubCaudals;
    map['release_date'] = null;
    map['user_id'] = SharedPref.getUserId();
    return map;
  }

  SnakeInfo.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.callerName = map['caller_name'];
    this.callerPhone = map['caller_phone'];
  }

  static http.MultipartRequest getMultiPartFields(multipartRequest, SnakeInfo formData) {
    multipartRequest.fields['snake_charm[rescue_date_time]'] = new DateTime(
        formData.rescueDate.year, formData.rescueDate.month,
        formData.rescueDate.day,
        formData.rescueTime.hour, formData.rescueTime.minute
    ).toString();
    multipartRequest.fields['snake_charm[user_id]'] = '1';
    multipartRequest.fields['snake_charm[caller_name]'] = formData.callerName;
    multipartRequest.fields['snake_charm[caller_phone]'] =
        formData.callerPhone.toString();
    multipartRequest.fields['snake_charm[address]'] = formData.address;
    multipartRequest.fields['snake_charm[village]'] = formData.village;
    multipartRequest.fields['snake_charm[pincode]'] = formData.pincode;
    multipartRequest.fields['snake_charm[country]'] = 'IND';
    multipartRequest.fields['snake_charm[snake_length]'] = formData.snakeLength;
    multipartRequest.fields['snake_charm[snake_length_unit]'] =
        formData.snakeLengthUnit;
    multipartRequest.fields['snake_charm[snake_weight]'] = formData.snakeWeight;
    multipartRequest.fields['snake_charm[snake_weight_unit]'] =
        formData.snakeWeightUnit;
    multipartRequest.fields['snake_charm[snake_sex]'] = formData.snakeSex;
    multipartRequest.fields['snake_charm[snake_behavior]'] =
        formData.snakeBehavior;
    multipartRequest.fields['snake_charm[snake_macro_habitat]'] =
        formData.macroHabitat;
    multipartRequest.fields['snake_charm[snake_micro_habitat]'] =
        formData.microHabitat;
    multipartRequest.fields['snake_charm[snake_condition]'] =
        formData.snakeCondition;
    multipartRequest.fields['snake_charm[snake_color]'] = formData.snakeColor;
    for (int i=0; i<formData.imagesInfo.length; i++){
      print('snake_charm[snake_photo_'+ i.toString() +']');
      print('snake_photo_' + i.toString());
      print(formData.imagesInfo[i]['snake_photo_' + i.toString()]);
      multipartRequest.fields['snake_charm[snake_photo_'+ i.toString() +']'] =
         formData.imagesInfo[i]['snake_photo_' + i.toString()].toString();
    }
    return multipartRequest;
  }


}