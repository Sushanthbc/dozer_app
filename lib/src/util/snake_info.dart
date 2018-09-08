part of dozer;

class SnakeInfo {
  int id;
  double snakeLength;
  String snakeLengthUnit;
  double snakeWeight;
  String snakeWeightUnit;
  String snakeSex;
  String snakeColor;
  String snakeBehavior;
  String snakeCondition;
  int dividedSubCaudals;
  int undividedSubCaudals;

  String rescueDateTime;

  String callerName;
  String callerPhone;
  String address;
  String pincode;
  String village;
  String macroHabitat;
  String microHabitat;


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
    this.rescueDateTime
  });
}