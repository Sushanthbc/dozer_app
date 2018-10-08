part of dozer;

//class NewUserForm extends StatelessWidget{
//  final UserInfo userInfo;
//  NewUserForm({Key key, @required this.userInfo}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//
//    return new Scaffold(
//      body: UserRegistrationForm()
//    );
//  }
//}

class UserRegistrationForm extends StatefulWidget {
  final AppUserInfo userInfo;

  UserRegistrationForm({Key key, this.userInfo}) : super(key: key);

  @override
  UserRegistrationFormState createState() {
    return UserRegistrationFormState();
  }
}

class UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool httpLoading = false;
  String _serverErr = "";

  //TODO: We have to move away from dropdown to something else
  List<String> _aboutList = ['Rescuer', 'Researcher', 'Enthusiast'];

  //UserInfo _userInfo;

  void submit() {
    setState(() {
      httpLoading = true;
    });
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _newUserReq = widget.userInfo.toMap();
      http.post(globals.baseURL +  "api/users",
          body: jsonEncode(_newUserReq),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          }).then((response) {
        if (response.statusCode == 200) {
          var resp = jsonDecode(response.body.toString());
          SharedPref.setUserIdPref(resp["user"]["id"], resp["user"]["admin"]);
          SharedPref.getUserDetails().then((userDetails) {
            if (userDetails["userId"] == null){
              globals.loggedInUserId = resp["user"]["id"];
              globals.isUserAdmin = resp["user"]["admin"];
            } else {
              globals.loggedInUserId = userDetails["userId"];
              globals.isUserAdmin = userDetails["isAdmin"];
            }
            Navigator.pushReplacementNamed(context, '/userSnakesList');
          });
        } else {
          setState(() {
            httpLoading = false;
            _serverErr = "Server Error. Please try again after sometime";
          });
        }
      }, onError: (err) {
        setState(() {
          httpLoading = false;
          _serverErr = "Server Error. Please try again after sometime";
        });
      });
    } else {
      setState(() {
        httpLoading = false;
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 80.0),
      child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: httpLoading

            ? new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[new CircularProgressIndicator()],
                )
              ],
            )

            : new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(
                    'Kalinga Foundation',
                    style: new TextStyle(fontSize: 20.0),
                  )
                ],
              ),

              new Padding(
                padding: EdgeInsets.all(20.0),
                child: new Column(
                  children: <Widget>[

                    new ListTile(
                      leading: new Icon(Icons.person),
                      title: new TextFormField(
                          initialValue: widget.userInfo.firstName,
                          decoration:
                          new InputDecoration(labelText: 'First Name'),
                          onSaved: (value) {
                            widget.userInfo.firstName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            } else if (value.length < 2){
                              return 'Name must be more than 2 characters';
                            }
                          }),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.person),
                      title: new TextFormField(
                          initialValue: widget.userInfo.lastName,
                          decoration:
                          new InputDecoration(labelText: 'Last Name'),
                          onSaved: (value) {
                            widget.userInfo.lastName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            } else if (value.length < 2){
                              return 'Name must be more than 2 characters';
                            } else {
                              return null;
                            }
                          }),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.phone),
                      title: new TextFormField(
                          initialValue: widget.userInfo.phone,
                          keyboardType: TextInputType.phone,
                          decoration: new InputDecoration(labelText: 'Phone'),
                          onSaved: (value) {
                            widget.userInfo.phone = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            } else if (value.length < 8) {
                              return 'Min : 7 digits';
                            } else if (value.length > 15) {
                              return 'Max : 15 digits';
                            } else {
                              return null;
                            }
                          }),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.email),
                      title: new TextFormField(
                        enabled: false,
                        initialValue: widget.userInfo.emailID,
                        decoration: new InputDecoration(labelText: 'Email'),
                        onSaved: (value) {
                          widget.userInfo.emailID = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.business),
                      title: new TextFormField(
                        initialValue: widget.userInfo.town,
                        decoration: new InputDecoration(labelText: 'Town/City'),
                        onSaved: (value) {
                          widget.userInfo.town = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.work),
                      title: new InputDecorator(
                        decoration: new InputDecoration(labelText: "About Me"),
                        child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              value: widget.userInfo.aboutUser,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  widget.userInfo.aboutUser = newValue;
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
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: new InputDecoration(
                              labelText: 'Purpose',
                              hintText:
                              'eg: I rescue King Cobras and \nwould like share my data \nfor research.'),
                          onSaved: (value) {
                            widget.userInfo.purpose = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                          }),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0,bottom: 30.0),
                      child: new RaisedButton(
                        onPressed: this.submit,
                        color: Colors.blue,
                        child: new Text(
                          'Submit',
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    _serverErr != ""
                    ? new Container(
                      margin: EdgeInsets.only(top:20.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text(
                            "Server Error. Please try again later",
                            style: new TextStyle(
                                color: Colors.red
                            ),
                          )
                        ],
                      ),
                    )
                    : new Container()

                  ],
                ),
              )
            ],
          )),
    );
  }
}
