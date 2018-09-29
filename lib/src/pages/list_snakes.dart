part of dozer;

String baseURL;

class ListSnakes extends StatelessWidget {
  final String listName;

  ListSnakes({Key key, @required this.listName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    baseURL = globals.baseURL + "api/snake_charms/";
    String appTitle;

    if (listName == "userRecords") {
      appTitle = "My Records";
      baseURL = baseURL + "single_snake_charm/";
    } else if (listName == "adminRecords") {
      appTitle = "All Records";
      baseURL = baseURL + "all_snake_charms/";
    }

    return new Scaffold(
        drawer: DrawerMain.mainDrawer(context),
        appBar: AppBar(
          title: Text(appTitle),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewRescueForm(
                        snakeInfo: new SnakeInfo(
                            rescueDate: new DateTime.now(),
                            rescueTime: new TimeOfDay.now(),
                            snakeCondition: 'Healthy',
                            snakeSex: 'Male',
                            snakeBehavior: 'Docile',
                            snakeLength: '',
                            snakeLengthUnit: 'Feet',
                            snakeWeight: '',
                            snakeWeightUnit: 'Kg',
                            snakeColor: 'Black',
                            macroHabitat: 'Plantation',
                            microHabitat: 'Cow Shed',
                            latitude: '',
                            longitude: '',
                            elevation: '',
                            elevationUnit: 'Feet',
                            images: [],
                            imagesInfo: [],
                            snakePhotos: []
                        ),
                      ),
                    ),
                  ).then((value){

                  });
                })
          ],
        ),
        body: new SnakesListView());
  }
}

class SnakesListView extends StatefulWidget {
  @override
  SnakesListViewState createState() {
    return SnakesListViewState();
  }
}

class SnakesListViewState extends State<SnakesListView> {
  int usrId = globals.loggedInUserId;

  Future _snakesList;
  @override
  initState() {
    super.initState();
    _snakesList = _getSnakesList();
  }

  Future<List<SnakeInfo>> _getSnakesList() async {
    final response = await http.get(baseURL +usrId.toString());
    var responseJson = json.decode(response.body.toString());
    List<SnakeInfo> snakesList = _createSnakesList(responseJson["snake_charm"]);
    return snakesList;
  }

  List<SnakeInfo> _createSnakesList(List dataFromServer) {
    List<SnakeInfo> list = new List();
    for (int i = 0; i < dataFromServer.length; i++) {
      SnakeInfo snakeInfo = new SnakeInfo(
          id: dataFromServer[i]["id"],
          snakeLength: dataFromServer[i]["snake_length"].toString(),
          snakeLengthUnit: dataFromServer[i]["snake_length_unit"],
          snakeWeight: dataFromServer[i]["snake_weight"].toString(),
          snakeWeightUnit: dataFromServer[i]["snake_weight_unit"],
          snakeColor: dataFromServer[i]["snake_color"],
          snakeSex: dataFromServer[i]["snake_sex"],
          dividedSubCaudals: dataFromServer[i]["snake_divided_sub_caudals"],
          undividedSubCaudals: dataFromServer[i]["snake_undivided_sub_caudals"],
          snakeCondition: dataFromServer[i]["snake_condition"],
          rescueDateTime: dataFromServer[i]["rescue_date_time"],
          callerName: dataFromServer[i]["caller_name"],
          callerPhone: dataFromServer[i]["caller_phone"].toString(),
          address: dataFromServer[i]["address"],
          village: dataFromServer[i]["village"],
          pincode: dataFromServer[i]["pincode"],
          macroHabitat: dataFromServer[i]["snake_macro_habitat"],
          microHabitat: dataFromServer[i]["snake_micro_habitat"]);
      list.add(snakeInfo);
    }
    return list;
  }

  Color _getColor(String snakeColor) {
    Color rgbColor = Color.fromRGBO(0, 0, 0, 1.0);
    if (snakeColor.toLowerCase() == 'brown') {
      rgbColor = Color.fromRGBO(165, 90, 42, 1.0);
    }
    return rgbColor;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<SnakeInfo>>(
      future: _snakesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return new ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  padding:
                                  EdgeInsets.only(left: 20.0, top: 10.0),
                                  child: new Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
                                        child: new Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: new Row(
                                            children: <Widget>[
                                              new Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: new Icon(Icons.palette,
                                                    color: _getColor(snapshot
                                                        .data[index]
                                                        .snakeColor)),
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: new Text(
                                                  snapshot.data[index]
                                                      .snakeColor +
                                                      ' ' +
                                                      snapshot
                                                          .data[index].snakeSex,
                                                  style: new TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 18.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              new IconButton(
                                  icon: new Icon(Icons.keyboard_arrow_right),
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(recordId : snapshot.data[index].id.toString()),
                                        ),
                                      );
                                  })
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                child: new Padding(
                                  padding:
                                  EdgeInsets.only(left: 20.0, top: 10.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: new Icon(Icons.compare_arrows,
                                            color: Colors.black54),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: new Text(snapshot
                                            .data[index].snakeLength
                                            .toString() +
                                            ' ' +
                                            snapshot
                                                .data[index].snakeLengthUnit),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              snapshot.data[index].snakeWeight != "null"
                              ? new Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: new Icon(Icons.fitness_center,
                                          color: Colors.black54),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: new Text(snapshot
                                          .data[index].snakeWeight
                                          .toString() +
                                          ' ' +
                                          snapshot.data[index].snakeWeightUnit),
                                    )
                                  ],
                                ),
                              )
                              : new Container()
                            ]

                          ),
                          new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                child: new Icon(Icons.location_on,
                                    color: Colors.black54),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                child: new Text(snapshot.data[index].village),
                              )
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new Text(DateTime.parse(
                                    snapshot.data[index].rescueDateTime)
                                    .day
                                    .toString() +
                                    '-' +
                                    DateTime.parse(
                                        snapshot.data[index].rescueDateTime)
                                        .month
                                        .toString() +
                                    '-' +
                                    DateTime.parse(
                                        snapshot.data[index].rescueDateTime)
                                        .year
                                        .toString() +
                                    ' ' +
                                    DateTime.parse(
                                        snapshot.data[index].rescueDateTime)
                                        .hour
                                        .toString() +
                                    ':' +
                                    DateTime.parse(
                                        snapshot.data[index].rescueDateTime)
                                        .minute
                                        .toString()),
                              )
                            ],
                          )
                        ],
                      ),
                      new Divider(
                        color: Colors.grey,
                      )
                    ]);
              });
          } else {
            return
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text(
                        'No records found.',
                        style: Theme.of(context).textTheme.title,
                      )
                    ],
                  )
                ],
              );
          }
        } else if (snapshot.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.error, color: Colors.red),
              Text('Error fetching data. Please try after sometime.')
            ],
          );
        }

        // By default, show a loading spinner
        return new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[new CircularProgressIndicator()],
            )
          ],
        );
      },
    );
  }
}
