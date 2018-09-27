part of dozer;


class UserProfile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: DrawerMain.mainDrawer(context),
      appBar: AppBar(
        title: Text("My Profile")
      ),
      body: UserProfileForm()
    );
  }
}

class UserProfileForm extends StatefulWidget {
  final AppUserInfo userInfo;

  UserProfileForm({Key key, this.userInfo}) : super(key: key);

  @override
  UserProfileFormState createState() {
    return UserProfileFormState();
  }
}

class UserProfileFormState extends State<UserProfileForm> {
  Future _future;
  initState() {
    super.initState();
    _future = _getUserProfile();
  }
  final _formKey = GlobalKey<FormState>();

  AppUserInfo _userInfo;

  Future<AppUserInfo> _getUserProfile() async {
    final response =
    await http.get(globals.baseURL + 'api/users/' + globals.loggedInUserId.toString());

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var resp = json.decode(response.body.toString());
      print(resp);
      _userInfo = AppUserInfo.fromMap(resp["user"]);
      return _userInfo;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  //TODO: We have to move away from dropdown to something else
  List<String> _aboutList = ['Rescuer', 'Researcher', 'Enthusiast'];

  //UserInfo _userInfo;

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _newUserReq = _userInfo.toMap();
      print(jsonEncode(_newUserReq));
      http.patch(globals.baseURL + "api/users/" + globals.loggedInUserId.toString(),
          body: jsonEncode(_newUserReq),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          }).then((response) {
            print(response.body.toString());
        if (response.statusCode == 200) {
          Scaffold.of(context).showSnackBar(
              SnackBar(
                  content: Text("Profile Updated")
              )
          );
        } else {
          // TODO handle new user registration error
          print("error");
        }
      }, onError: (err) {
        print('error checking first user');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(1.0),
      child: FutureBuilder<AppUserInfo>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Form(
                key: _formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(0.0),
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: new Icon(Icons.person),
                            title: new TextFormField(
                                initialValue: _userInfo.firstName,
                                decoration:
                                new InputDecoration(labelText: 'First Name'),
                                onSaved: (value) {
                                  _userInfo.firstName = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                }),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.person),
                            title: new TextFormField(
                                initialValue: snapshot.data.lastName,
                                decoration:
                                new InputDecoration(labelText: 'Last Name'),
                                onSaved: (value) {
                                  snapshot.data.lastName = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                }),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.phone),
                            title: new TextFormField(
                                initialValue: snapshot.data.phone,
                                keyboardType: TextInputType.phone,
                                decoration: new InputDecoration(labelText: 'Phone'),
                                onSaved: (value) {
                                  snapshot.data.phone = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                }),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.email),
                            title: new TextFormField(
                              enabled: false,
                              initialValue: snapshot.data.emailID,
                              decoration: new InputDecoration(labelText: 'Email'),
                              onSaved: (value) {
                                snapshot.data.emailID = value;
                              },
                            ),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.work),
                            title: new InputDecorator(
                              decoration: new InputDecoration(labelText: "About Me"),
                              child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton<String>(
                                    value: snapshot.data.aboutUser,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        snapshot.data.aboutUser = newValue;
                                      });
                                    },
                                    items: _aboutList.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                  )),
                            ),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.description),
                            title: new TextFormField(
                                initialValue: snapshot.data.purpose,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                decoration: new InputDecoration(
                                    labelText: 'Purpose',
                                    hintText:
                                    'eg: I rescue King Cobras and \nwould like share my data \nfor research.'),
                                onSaved: (value) {
                                  snapshot.data.purpose = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                }),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new RaisedButton(
                              onPressed: this.submit,
                              color: Colors.blue,
                              child: new Text(
                                'Update',
                                style: new TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),

    );
  }
}
