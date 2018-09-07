part of dozer;

class NewUserForm extends StatelessWidget{
  final UserInfo userInfo;
  NewUserForm({Key key, @required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: UserRegistrationForm()
    );
  }
}


class UserRegistrationForm extends StatefulWidget{
  @override
  UserRegistrationFormState createState(){
    return UserRegistrationFormState();
  }
}


class UserRegistrationFormState extends State<UserRegistrationForm>{

  final _formKey = GlobalKey<FormState>();

  List<String> _aboutList = ['Rescuer','Researcher','Enthusiast'];


  //UserInfo _userInfo;

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
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
                      decoration: new InputDecoration(
                          labelText: 'Name'
                      ),
                      onSaved: (value){
                        _userInfo.name = value;
                      },
                    ),
                  ),

                  new ListTile(
                    leading: new Icon(Icons.phone),
                    title: new TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                          labelText: 'Phone'
                      ),
                      onSaved: (value){
                        _userInfo.phone = value;
                      },
                    ),
                  ),

                  new ListTile(
                    leading: new Icon(Icons.email),
                    title: new TextFormField(
                      enabled: false,
                      initialValue: _userInfo.email,
                      decoration: new InputDecoration(
                        labelText: 'Email'
                      ),
                      onSaved: (value){
                        _userInfo.email = value;
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
                              value: _userInfo.about,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _userInfo.about = newValue;
                                });
                              },
                              items: _aboutList.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }
                              ).toList()
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
                        hintText: 'I rescue King Cobras and \nwould like share my data \nfor research.'
                      ),
                      onSaved: (value){
                        _userInfo.purpose = value;
                      },
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
    );

  }
}
