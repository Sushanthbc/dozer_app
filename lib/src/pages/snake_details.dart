part of dozer;

class DetailScreen extends StatelessWidget {

  final SnakeInfo snakeInfo;

  DetailScreen({Key key, @required this.snakeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(
                    "Page still under development",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              new Padding(
                padding: EdgeInsets.only(top:30.0),
                child: new Text("${snakeInfo.snakeSex} King Cobra"),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Color : ${snakeInfo.snakeColor}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                  "Length : ${snakeInfo.snakeLength} ${snakeInfo.snakeLengthUnit}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Weight : ${snakeInfo.snakeWeight} ${snakeInfo.snakeWeightUnit}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Status : ${snakeInfo.snakeCondition}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Behavior : ${snakeInfo.snakeBehavior}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Macrohabitat : ${snakeInfo.macroHabitat}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Microhabitat : ${snakeInfo.microHabitat}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:40.0),
                child: new Text(
                    "Caller Name : ${snakeInfo.callerName}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Caller Phone : ${snakeInfo.callerPhone}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Address : ${snakeInfo.address}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Village : ${snakeInfo.village}"
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:20.0),
                child: new Text(
                    "Pincode : ${snakeInfo.pincode}"
                ),
              )

            ],
          ),
        )
      ),
    );
  }
}
