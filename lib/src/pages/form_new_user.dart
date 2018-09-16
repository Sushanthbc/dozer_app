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


class UserRegistrationForm extends StatefulWidget{
  final AppUserInfo userInfo;
  UserRegistrationForm({Key key, this.userInfo}) : super(key: key);
  @override
  UserRegistrationFormState createState(){
    return UserRegistrationFormState();
  }
}


class UserRegistrationFormState extends State<UserRegistrationForm>{

  final _formKey = GlobalKey<FormState>();

  //TODO: We have to move away from dropdown to something else
  List<String> _aboutList = ['Rescuer','Researcher','Enthusiast'];


  //UserInfo _userInfo;

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _newUserReq = widget.userInfo.toMap();
      http.post(
          "https://morning-castle-37512.herokuapp.com/api/users",
          body: jsonEncode(_newUserReq),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          }
      ).then((response){
        if (response.statusCode == 200) {
          var resp = jsonDecode(response.body.toString());
          SharedPref.setUserIdPref(resp["user"]["id"], resp["user"]["admin"]);
          Navigator.pushReplacementNamed(context, '/snakesList');
        } else {
          // TODO handle new user registration error
        }

      }, onError: (err){
        print('error checking first user');
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 80.0),
      child: new Form(
          key: _formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(
                    'Kalinga Foundation',
                    style: new TextStyle(
                        fontSize: 20.0
                    ),
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
                        decoration: new InputDecoration(
                            labelText: 'First Name'
                        ),
                        onSaved: (value){
                          widget.userInfo.firstName = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required';
                          }
                        }
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.person),
                      title: new TextFormField(
                          initialValue: widget.userInfo.lastName,
                          decoration: new InputDecoration(
                              labelText: 'Last Name'
                          ),
                          onSaved: (value){
                            widget.userInfo.lastName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                          }
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.phone),
                      title: new TextFormField(
                        initialValue: widget.userInfo.phone,
                        keyboardType: TextInputType.phone,
                        decoration: new InputDecoration(
                            labelText: 'Phone'
                        ),
                        onSaved: (value){
                          widget.userInfo.phone = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required';
                          }
                        }
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.email),
                      title: new TextFormField(
                        enabled: false,
                        initialValue: widget.userInfo.emailID,
                        decoration: new InputDecoration(
                            labelText: 'Email'
                        ),
                        onSaved: (value){
                          widget.userInfo.emailID = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.work),
                      title: new InputDecorator(
                        decoration: new InputDecoration(
                            labelText: "About Me"
                        ),
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
                                }
                                ).toList(),
                            )
                        ),
                      ),
                    ),

                    new ListTile(
                      leading: new Icon(Icons.description),
                      title: new TextFormField(
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                            labelText: 'Purpose',
                            hintText: 'eg: I rescue King Cobras and \nwould like share my data \nfor research.'
                        ),
                        onSaved: (value){
                          widget.userInfo.purpose = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required';
                          }
                        }
                      ),
                    ),


                    new Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new RaisedButton(
                        onPressed: this.submit,
                        color: Colors.blue,
                        child: new Text(
                          'Submit',
                          style: new TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              )

            ],
          )
      ),
    );

  }
}
