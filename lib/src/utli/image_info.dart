part of dozer;


class SnakeImageInfo extends StatefulWidget{

  Map imageInfo;

  final File snakePhoto;

  SnakeImageInfo({Key key, @required this.snakePhoto}) : super(key: key);

  @override
  SnakeImageInfoState createState(){
    return SnakeImageInfoState();
  }

}

Map imageInfo = {
  "headLateralLeft" : false,
  "headLateralRight" : false,
  "rostral": false,
  "headDorsal": false,
  "hoodDorsal" : false,
  "fullBody": false,
  "subcaudals": false
};

class ImageData {
  bool headLateralLeft;
  bool headLateralRight;
  bool rostral;
  bool headDorsal;
  bool hoodDorsal;
  bool fullBody;
  bool subcaudals;

  ImageData.fromJson(Map json){
    this.headLateralRight = json["headLateralRight"];
    this.headLateralLeft = json["headLateralLeft"];
    this.rostral = json["rostral"];
    this.headDorsal = json["headDorsal"];
    this.hoodDorsal = json["hoodDorsal"];
    this.fullBody = json["fullBody"];
    this.subcaudals = json["subcaudals"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["headLateralLeft"] = headLateralLeft;
    map["headLateralRight"] = headLateralRight;
    map["rostral"] = rostral;
    map["headDorsal"] = headDorsal;
    map["hoodDorsal"] = hoodDorsal;
    map["fullBody"] = fullBody;
    map["subcaudals"] = subcaudals;
    return map;
  }
}


ImageData _data = new ImageData.fromJson(imageInfo);

class SnakeImageInfoState extends State<SnakeImageInfo>{

  @override
  void initState(){
    _data.headLateralRight = false;
    _data.headLateralLeft = false;
    _data.rostral = false;
    _data.headDorsal = false;
    _data.hoodDorsal = false;
    _data.fullBody = false;
    _data.subcaudals = false;
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(40.0),
          child: new Column(
            children: <Widget>[
              new Image.file(
                widget.snakePhoto,
                height: 100.0,
              ),
              new Text(
                  'What information does this photo contain? Please select.'
              ),
              new CheckboxListTile(
                  title: new Text('Head Lateral - Left'),
                  value: _data.headLateralLeft,
                  onChanged: (val) {
                    setState(() {
                      _data.headLateralLeft = val;
                    });
                  }
              ),

              new CheckboxListTile(
                  title: new Text('Head Lateral - Right'),
                  value: _data.headLateralRight,
                  onChanged: (val) {
                    setState(() {
                      _data.headLateralRight = val;
                    });
                  }
              ),

              new CheckboxListTile(
                  title: new Text('Rostral'),
                  value: _data.rostral,
                  onChanged: (val) {
                    setState(() {
                      _data.rostral = val;
                    });
                  }
              ),

              new CheckboxListTile(
                  title: new Text('Head Dorsal'),
                  value: _data.headDorsal,
                  onChanged: (val){
                    setState(() {
                      _data.headDorsal = val;
                    });
                  }
              ),

              new CheckboxListTile(
                  title: new Text('Hood Dorsal'),
                  value: _data.hoodDorsal,
                  onChanged: (val){
                    setState(() {
                      _data.hoodDorsal = val;
                    });
                  }
              ),

              new CheckboxListTile(
                  title: new Text('Full Body'),
                  value: _data.fullBody,
                  onChanged: (val) {
                    setState(() {
                      _data.fullBody = val;
                    });
                  }
              ),
              new CheckboxListTile(
                  title: new Text('Subcaudals'),
                  value: _data.subcaudals,
                  onChanged: (val) {
                    setState(() {
                      _data.subcaudals = val;
                    });
                  }
              ),
              new RaisedButton(
                  onPressed: (){
                    Navigator.pop(context, _data.toMap());
                  },
                  child: new Text(
                    'Done',
                    style: new TextStyle(
                      color: Colors.white
                    ),
                  ),
                color: Colors.blue,
              )
            ],
          ),
        ),
      )
    );
  }

}