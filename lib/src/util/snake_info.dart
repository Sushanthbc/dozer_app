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

  String generalRemarks;
  String biteReport;

  List<File> images;
  List snakePhotos;
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
    this.imagesInfo,
    this.snakePhotos,
    this.generalRemarks,
    this.biteReport
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
    if (snakeWeight !=  null && snakeWeight !=  "") {
      map['snake_weight'] = double.parse(snakeWeight);
    }
    map['snake_weight_unit'] = snakeWeightUnit;
    map['snake_sex'] = snakeSex;
    map['snake_color'] = snakeColor;
    map['snake_behavior'] = snakeBehavior;
    map['snake_micro_habitat'] = microHabitat;
    map['snake_macro_habitat'] = macroHabitat;
    map['snake_condition'] = snakeCondition;
    map['snake_caudals'] = "D:" + dividedSubCaudals + ";" + "U:" + undividedSubCaudals;
    map['release_date'] = null;
    map['user_id'] = globals.loggedInUserId;
    if (latitude != null){
      map['latitude'] = latitude;
    }
    if (longitude != null){
      map['longitude'] = longitude;
    }
    if (elevation != null){
      map['elevation'] = elevation;
      map['elevation_unit'] = elevationUnit;
    }
    if (generalRemarks != null){
      map['general_remarks'] = generalRemarks;
    }
    if (biteReport != null){
      map['bite_report'] = biteReport;
    }
    return map;
  }

  SnakeInfo.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.rescueDateTime= map["rescue_date_time"];
    this.rescueDate = DateTime.parse(map["rescue_date_time"]);
    this.rescueTime = TimeOfDay.fromDateTime(DateTime.parse(map["rescue_date_time"]));
    this.callerName = map['caller_name'];
    this.callerPhone = map['caller_phone'];
    this.snakeLength = map["snake_length"].toString();
    this.snakeLengthUnit = map["snake_length_unit"];
    this.snakeColor = map["snake_color"];
    this.snakeSex = map["snake_sex"];

    if (map["snake_weight"].toString() == "null"){
      this.snakeWeight = "";
    } else {
      this.snakeWeight = map["snake_weight"].toString();
    }
    this.snakeWeightUnit = map["snake_weight_unit"];

    //this.dividedSubCaudals= map["snake_caudals"]["divided"];
    //this.undividedSubCaudals= map["snake_caudals"]["undivided"];

    if (map["snake_caudals"]!="D:;U:"){
      List<String> _caudals = map["snake_caudals"].toString().split(";");
      String _dividedCaudals = _caudals[0].split(":")[1];
      String _undividedCaudals = _caudals[1].split(":")[1];
      this.dividedSubCaudals = _dividedCaudals;
      this.undividedSubCaudals = _undividedCaudals;
    } else {
      this.dividedSubCaudals = "";
      this.undividedSubCaudals = "";
    }

    if (map['latitude'] != null){
      this.latitude = map['latitude'];
    }
    if (map['longitude'] != null){
      this.longitude = map['longitude'];
    }
    if (map['elevation'] != null){
      this.elevation = map['elevation'];
      this.elevationUnit = map['elevation_unit'];
    }
    if (map['general_remarks'] != null){
      this.generalRemarks = map['general_remarks'];
    }
    if (map['bite_report'] != null){
      this.biteReport = map['bite_report'];
    }

    this.snakeCondition= map["snake_condition"];
    this.snakeBehavior = map["snake_behavior"];
    this.callerName= map["caller_name"];
    this.callerPhone= map["caller_phone"].toString();
    this.address= map["address"];
    this.village= map["village"];
    this.pincode= map["pincode"];
    this.macroHabitat= map["snake_macro_habitat"];
    this.microHabitat= map["snake_micro_habitat"];
    this.images = [];
    
    // Photo links
    if (map["snake_photos"].length > 0) {
      this.snakePhotos = map["snake_photos"];
    } else {
      this.snakePhotos = [];
    }
  }

  static http.MultipartRequest getMultiPartFields(multipartRequest, SnakeInfo formData) {
    multipartRequest.fields['snake_charm[rescue_date_time]'] = new DateTime(
        formData.rescueDate.year, formData.rescueDate.month,
        formData.rescueDate.day,
        formData.rescueTime.hour, formData.rescueTime.minute
    ).toString();
    multipartRequest.fields['snake_charm[user_id]'] = globals.loggedInUserId.toString();
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
    multipartRequest.fields['snake_charm[snake_caudals]'] =
        "D:" + formData.dividedSubCaudals + ";" + "U:" + formData.undividedSubCaudals;

    if (formData.latitude != null){
      multipartRequest.fields['snake_charm[latitude]'] = formData.latitude;
    }
    if (formData.longitude != null){
      multipartRequest.fields['snake_charm[longitude]'] = formData.longitude;
    }
    if (formData.elevation != null){
      multipartRequest.fields['snake_charm[elevation]'] = formData.elevation;
      multipartRequest.fields['snake_charm[elevation_unit]'] = formData.elevationUnit;
    }
    if (formData.generalRemarks != null){
      multipartRequest.fields['snake_charm[general_remarks]'] = formData.generalRemarks;
    }
    if (formData.biteReport != null){
      multipartRequest.fields['snake_charm[bite_report]'] = formData.biteReport;
    }

    /*for (int i=0; i<formData.imagesInfo.length; i++){
      print('snake_charm[snake_photo_'+ i.toString() +']');
      print('snake_photo_' + i.toString());
      print(formData.imagesInfo[i]['snake_photo_' + i.toString()]);
      multipartRequest.fields['snake_charm[snake_photo_'+ i.toString() +']'] =
         formData.imagesInfo[i]['snake_photo_' + i.toString()].toString();
    }*/
    return multipartRequest;
  }


}