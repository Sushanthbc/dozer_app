part of dozer;


class FormSnake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'KCRE';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
            title: Text(appTitle)
        ),
        body: MyCustomForm(),
      ),
    );

  }
}


// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class _KcData {
  String callerName = '';
  String address = '';
  String pincode;
  String town = '';
  String phone = '';
  DateTime rescueDate = new DateTime.now();
  TimeOfDay rescueTime = new TimeOfDay.now();
  String latitude = '';
  String longitude = '';
  String elevation = '';
  String macroHabitat = null;
  String microHabitat = null;
  String condition = null;
  String length = '';
  String length_unit = 'feet';
  String weight = '';
  String weight_unit = 'kg';
  String sex = 'Male';
  String subcaudal = 'Divided';
  int subcaudal_val = 70;
  String kc_color = 'Black';
  String behavior = 'Docile';
  DateTime releaseDate;
  TimeOfDay releaseTime;
  String bite_report;
  String general_remarks;
  File image;
  List<File> images = [];


  Map geoLocation = {
    "coordinates": {
      "lat" : "0",
      "lng" : 0
    },
    "elevation": {
      "unit": "m",
      "value": 0
    }
  };
}


// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();



  _KcData _data = new _KcData();

  // Image picker
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _data.images.add(image);
      print(_data.images);
    });
  }

  List<String> _macroHabitats = <String>['House', 'Plantation', 'Agricultural Field', 'Forest'];
  List<String> _microHabitats = <String>['Bedroom', 'Kitchen', 'Hall', 'Bathroom', 'Cow Shed'];
  List<String> _conditions = <String>['Healthy','Weak','Shedding'];
  List<String> _subcaudals = <String>['Divided', 'Undivided'];
  List<String> _kc_colors = <String>['Black', 'Brown', 'Blackish Brown', 'Brownish Black', 'Olive Brown', 'Olive Green'];
  List<String> _behaviors = <String>['Docile', 'Defensive'];
  List<String> _lengthUnits = <String>['feet', 'metres'];
  List<String> _weightUnits = <String>['kg','lbs'];

  Color _maleButtonColor = Colors.grey;
  Color _maleButtonBackground = Colors.black12;

  Color _femaleButtonColor = Colors.grey;
  Color _femaleButtonBackground = Colors.black12;



  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      print('####### Printing the submitted data.');

      var req = {
        "snake_charm": {
          "rescue_date_time": new DateTime(_data.rescueDate.year, _data.rescueDate.month, _data.rescueDate.day, _data.rescueTime.hour, _data.rescueTime.minute).toString(),
          "address": _data.address,
          "village": _data.town,
          "pincode": int.parse(_data.pincode),
          "country": "IN", //YTI
          "caller_name": _data.callerName,
          "caller_phone": int.parse(_data.phone),
          "snake_length": int.parse(_data.length),
          "snake_length_unit": _data.length_unit,
          "snake_weight": int.parse(_data.weight),
          "snake_weight_unit": _data.weight_unit,
          "snake_sex": _data.sex,
          "snake_color": _data.kc_color,
          "snake_divided_sub_caudals": _data.subcaudal_val,
          "snake_undivided_sub_caudals": _data.subcaudal_val,
          "snake_behavior": _data.behavior,
          "snake_micro_habitat": _data.microHabitat,
          "snake_macro_habitat": _data.macroHabitat,
          "snake_condition": _data.condition,
          "release_date": null,
          "user_id": 1
        }
      };
      print(jsonEncode(req));
      http.post(
          "https://morning-castle-37512.herokuapp.com/api/snake_charms",
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          },
          body: jsonEncode(req)
      ).then(
              (response){
            print(response.body);
          }
      );


    } else {
      print('validation failed');
    }
  }

  Future<DateTime> _chooseDate(BuildContext context, DateTime initialDate) async {
    var now = new DateTime.now();
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;
    setState(() {
      _data.rescueDate = result;
    });

  }

  Future<TimeOfDay> _chooseTime(BuildContext context, TimeOfDay initialTime) async {
    var timenow = new TimeOfDay.now();

    var result = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (result == null) return;
    setState(() {
      _data.rescueTime = result;
    });
  }


  @override
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey we created above
    return SingleChildScrollView(
        child:  Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                new ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text('Rescue Date: ' + formatDate(_data.rescueDate, ['dd','-','mm','-','yyyy'])),
                      new IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () => _chooseDate(context, new DateTime.now())
                      )
                    ],
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.timer),
                  title: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text('Rescue Time: ${_data.rescueTime.format(context)}'),
                      new IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () => _chooseTime(context, new TimeOfDay.now())
                      )
                    ],
                  ),
                ),

                new ListTile(
                    leading: const Icon(Icons.person),
                    title: new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Caller Name'
                      ),
                      onSaved: (value){
                        _data.callerName = value;
                      },
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.phone),
                    title: new TextFormField(
                      decoration: new InputDecoration(
                          labelText: "Caller Phone"
                      ),
                      onSaved: (value){
                        _data.phone = value;
                      },
                    )
                ),

                new ListTile(
                  leading: const Icon(Icons.location_on),
                  title: new TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Address'
                    ),
                    onSaved: (value){
                      this._data.address = value;
                    },
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.local_post_office),
                  title: new TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Pincode'
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value){
                      this._data.pincode = value;
                    },
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.location_city),
                  title: new TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Village/Town'
                    ),
                    onSaved: (value){
                      this._data.town = value;
                    },
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.location_on),
                  title: new TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Latitude'
                    ),
                    onSaved: (value){
                      this._data.geoLocation['coordinates']['lat'] =  value;
                    },
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.location_on),
                  title: new TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Longitude'
                    ),
                    onSaved: (value){
                      this._data.geoLocation['coordinates']['lng'] =  value;
                    },
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.airplanemode_active),
                  title: new TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Elevation'
                    ),
                    onSaved: (value){
                      this._data.geoLocation['elevation']['value'] =  value;
                    },
                  ),
                ),

                new ListTile(
                    leading: const Icon(Icons.note),
                    title: new DropdownButton<String>(
                        hint: Text('Macrohabitat'),
                        value: _data.macroHabitat,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _data.macroHabitat = newValue;
                          });
                        },
                        items: _macroHabitats.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }
                        ).toList()
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.home),
                    title: new DropdownButton<String>(
                        hint: Text('Microhabitat'),
                        value: _data.microHabitat,
                        onChanged: (String newValue) {
                          setState(() {
                            _data.microHabitat = newValue;
                          });
                        },
                        items: _microHabitats.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList()
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.local_hospital),
                    title: new DropdownButton<String>(
                        hint: Text('Condition'),
                        value: _data.condition,
                        onChanged: (String newValue) {
                          setState(() {
                            _data.condition = newValue;
                          });
                        },
                        items: _conditions.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList()
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.compare_arrows),
                    title: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Length',
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value){
                              _data.length = value;
                            },
                          ),
                        ),
                        new Container(
                          width: 75.0,
                          child: new InputDecorator(
                            decoration: new InputDecoration(
                                labelText: 'Unit'
                            ),
                            child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                    value: _data.length_unit,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _data.length_unit = newValue;
                                      });
                                    },
                                    items: _lengthUnits.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList()
                                )
                            ),
                          ),
                        )
                      ],
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Weight',
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value){
                              _data.weight = value;
                            },
                          ),
                        ),
                        new Container(
                          width: 75.0,
                          child: new InputDecorator(
                            decoration: new InputDecoration(
                                labelText: 'Unit'
                            ),
                            child: new DropdownButton<String>(
                                value: _data.weight_unit,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _data.weight_unit = newValue;
                                  });
                                },
                                items: _weightUnits.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList()
                            ),
                          ),
                        )
                      ],
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.people),
                    title: new InputDecorator(
                      decoration: new InputDecoration(
                          labelText: 'Sex'
                      ),
                      child: new DropdownButton<String>(
                          value: _data.sex,
                          onChanged: (String newValue) {
                            setState(() {
                              _data.sex = newValue;
                            });
                          },
                          items: ['Male', 'Female'].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList()
                      ),
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.straighten),
                    title: new DropdownButton<String>(
                        hint: Text('Subcaudals'),
                        value: _data.subcaudal,
                        onChanged: (String newValue) {
                          setState(() {
                            _data.subcaudal = newValue;
                          });
                        },
                        items: _subcaudals.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList()
                    )
                ),

                new ListTile(
                    leading: new Padding(padding: EdgeInsets.all(25.0)),
                    title: new TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 100,
                      decoration: new InputDecoration(
                        labelText: "#Subcaudals",
                      ),
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.palette),
                    title: new DropdownButton<String>(
                        hint: Text('Color'),
                        value: _data.kc_color,
                        onChanged: (String newValue) {
                          setState(() {
                            _data.kc_color = newValue;
                          });
                        },
                        items: _kc_colors.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList()
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.security),
                    title: new DropdownButton<String>(
                        hint: Text('Behavior'),
                        value: _data.behavior,
                        onChanged: (String newValue) {
                          setState(() {
                            _data.behavior = newValue;
                          });
                        },
                        items: _behaviors.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList()
                    )
                ),

                new ListTile(
                  leading: new IconButton(
                      icon: new Icon(Icons.photo_library),
                      onPressed: getImage
                  ),
                ),



                // Form Submit button
                new RaisedButton(
                  child: new Text(
                    'Submit',
                    style: new TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: this.submit,
                  color: Colors.blue,
                )

              ],
            )
        )
    );
  }
}