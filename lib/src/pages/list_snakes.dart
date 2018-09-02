part of dozer;

class ListSnakes extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final appTitle = 'List';

    return new Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.pushNamed(context, '/snakeForm');
              }
          )
        ],
      ),
      body: new SnakesListView()
    );

  }
}

class SnakesListView extends StatefulWidget{
  @override
  SnakesListViewState createState(){
    return SnakesListViewState();
  }
}

class User {
  double snake_length;
  String snake_length_unit;
  double snake_weight;
  String snake_weight_unit;
  String snake_sex;
  String snake_color;
  String village;
  String rescue_date_time;
  int id;
  User({
    this.snake_length,
    this.snake_length_unit,
    this.snake_weight,
    this.snake_weight_unit,
    this.snake_sex,
    this.snake_color,
    this.village,
    this.rescue_date_time
  });
}

class SnakesListViewState extends State<SnakesListView>{

  Future<List<User>> _getSnakesList() async {
    final response = await http.get('https://morning-castle-37512.herokuapp.com/api/snake_charms');
    print('GET request');
    print(response.body);
    var responseJson = json.decode(response.body.toString());
    List<User> userList = createUserList(responseJson["snake_charm"]);
    return userList;

  }

  List<User> createUserList(List data){
    List<User> list = new List();
    for (int i = 0; i < data.length; i++) {
      User user = new User(
        village: data[i]["village"],
        snake_length: data[i]["snake_length"],
        snake_length_unit: data[i]["snake_length_unit"],
        snake_weight: data[i]["snake_weight"],
        snake_weight_unit: data[i]["snake_weight_unit"],
        snake_color: data[i]["snake_color"],
        snake_sex: data[i]["snake_sex"],
        rescue_date_time: data[i]["rescue_date_time"]
      );
      list.add(user);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {

    return new FutureBuilder<List<User>>(
      future:  _getSnakesList(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return new ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Card(
                        margin: EdgeInsets.all(10.0),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text(
                                      snapshot.data[index].village,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0
                                      )
                                  ),
                                )
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text(snapshot.data[index].snake_color + ' ' + snapshot.data[index].snake_sex),
                                ),
                                new Container(
                                  child: new Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.compare_arrows),
                                        new Text(snapshot.data[index].snake_length.toString() + ' ' +  snapshot.data[index].snake_length_unit),
                                      ],
                                    ),
                                  ),
                                ),
                                new Container(
                                  child: new Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: new Icon(Icons.fitness_center),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: new Text(
                                          snapshot.data[index].snake_weight.toString() + ' ' + snapshot.data[index].snake_weight_unit
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                //new Text(snapshot.data[index].snake_length_unit)
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text(
                                    DateTime.parse(snapshot.data[index].rescue_date_time).day.toString() + '-' +
                                    DateTime.parse(snapshot.data[index].rescue_date_time).month.toString() + '-' +
                                    DateTime.parse(snapshot.data[index].rescue_date_time).year.toString() + ' ' +
                                    DateTime.parse(snapshot.data[index].rescue_date_time).hour.toString() + ':' +
                                        DateTime.parse(snapshot.data[index].rescue_date_time).minute.toString()
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )

                    ]
                );
              }
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }

        // By default, show a loading spinner
        return new CircularProgressIndicator();
      },
    );

  }

}

