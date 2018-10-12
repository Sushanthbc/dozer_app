part of dozer;

SnakeInfo snakeInfo;

class DetailScreen extends StatelessWidget{

  final String recordId;

  DetailScreen({Key key, this.recordId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
            title: Text("Rescue Detail"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed:() => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewRescueForm(
                      snakeInfo: snakeInfo,
                    ),
                  ),
                )
            )
          ],
        ),
        body: RescueDetail(id: this.recordId,)
    );
  }
}

class RescueDetail extends StatefulWidget {

  final String id;

  RescueDetail({Key key, this.id}) : super(key: key);

  @override
  RescueDetailState createState() {
    return RescueDetailState();
  }
}

class RescueDetailState extends State<RescueDetail> {
  Future _future;
  initState() {
    super.initState();
    _future = _getRescueDetail();

  }
  final _formKey = GlobalKey<FormState>();



  Future<SnakeInfo> _getRescueDetail() async {
    final response =
    await http.get(globals.baseURL + 'api/snake_charms/' + widget.id);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var resp = json.decode(response.body.toString());
      snakeInfo = SnakeInfo.fromMap(resp);
      return snakeInfo;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(1.0),
      child: FutureBuilder<SnakeInfo>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                ListTile(
                  leading: null,
                  title: Text(
                    "${snakeInfo.snakeColor} ${snakeInfo.snakeSex} King Cobra",
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),

                ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Rescue Date"),
                        Text(formatDate(DateTime.parse(snakeInfo.rescueDateTime),
                            [dd, '-', mm, '-', yyyy, ' ', HH, ':', nn]))
                      ],
                    )

                ),

                ListTile(
                    leading: const Icon(Icons.visibility),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Nature of Sighting"),
                        Text("${snakeInfo.natureOfSighting}")
                      ],
                    )

                ),

                ListTile(
                  leading: const Icon(Icons.compare_arrows),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Length"),
                      Text(
                          "${snakeInfo.snakeLength} ${snakeInfo.snakeLengthUnit}"
                      )
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Weight"),
                      snakeInfo.snakeWeight == ""
                      ? Text("N/A")
                      : Text(
                          "${snakeInfo.snakeWeight} ${snakeInfo.snakeWeightUnit}"
                      )
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.local_hospital),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Condition"),
                      Text(
                          snakeInfo.snakeCondition
                      )
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.security),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Behavior"),
                      Text(
                          "${snakeInfo.snakeBehavior}"
                      )
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.public),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Macrohabitat"),
                      Text(
                          snakeInfo.macroHabitat
                      )
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.home),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Microhabitat"),
                      Text(
                          snakeInfo.microHabitat
                      )
                    ],
                  ),
                ),

                ListTile(
                    leading: const Icon(Icons.texture),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("No. of Bands"),
                        snakeInfo.cntBands == ""
                            ? Text("N/A")
                            : Text("${snakeInfo.cntBands}")
                      ],
                    ),
                ),

                ListTile(
                  leading: const Icon(Icons.straighten),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Subcaudals"),
                      snakeInfo.dividedSubCaudals == ""
                      ? Text("N/A")
                      : Container()
                    ],
                  ),
                  subtitle:
                  snakeInfo.dividedSubCaudals == ""
                  ? Container()
                  : new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Divided:"),
                          Text(snakeInfo.dividedSubCaudals)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Undivided:"),
                          Text(snakeInfo.undividedSubCaudals)
                        ],
                      )
                    ],
                  )
                ),

                new Padding(
                  padding: EdgeInsets.only(top:40.0, left:20.0, bottom: 20.0),
                  child: new Text(
                    "Caller Information :",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Name"),
                        Text(
                            snakeInfo.callerName
                        )
                      ]
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.phone),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Phone"),
                        Text(
                            snakeInfo.callerPhone
                        )
                      ]
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: new Row(
                    children: <Widget>[
                      new Flexible(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                                snakeInfo.address)
                          ],
                        ),
                      ),
                    ],
                  )
                ),

                ListTile(
                  leading: const Icon(Icons.business),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Town/City"),
                        Text(
                            snakeInfo.village
                        )
                      ]
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.local_post_office),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Pincode"),
                        Text(
                            snakeInfo.pincode
                        )
                      ]
                  ),
                ),

                new Padding(
                  padding: EdgeInsets.only(top:40.0, left:20.0, bottom: 20.0),
                  child: new Text(
                    "Rescued By :",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Name"),
                        Text(
                          "${snakeInfo.rescuerDetail["first_name"]} ${snakeInfo.rescuerDetail["last_name"]}"
                        )
                      ]
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.phone),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Phone"),
                        Text(
                            "${snakeInfo.rescuerDetail["phone"]}"
                        )
                      ]
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.mail),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Email"),
                        Text(
                            "${snakeInfo.rescuerDetail["email_id"]}"
                        )
                      ]
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.work),
                  title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("About User"),
                        Text(
                            "${snakeInfo.rescuerDetail["about_user"]}"
                        )
                      ]
                  ),
                ),

                snakeInfo.snakePhotos.length > 0
                    ? new GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    crossAxisCount: 3,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,

                    children:
                    List.generate(snakeInfo.snakePhotos.length, (index) {
                      return Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KcImageViewer(
                                        imageURL: snakeInfo.snakePhotos[index],
                                      ),
                                    ),
                                  );
                                },
                                child: new Image.network(
                                  snakeInfo.snakePhotos[index],
                                  height: 90.0,
                                ),
                              ),

                            ],
                          ));
                    }))
                    : new Container(),

              ],
            )
            ;
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[new CircularProgressIndicator()],
              )
            ],
          );
        },
      ),

    );
  }
}
