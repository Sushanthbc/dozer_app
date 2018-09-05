part of dozer;


class FormSnake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Rescue Form';

    return new Scaffold(
        appBar: AppBar(
            title: Text(appTitle)
        ),
        body: MyCustomForm(),
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
  String pinCode;
  String town = '';
  String phone = '';
  DateTime rescueDate = new DateTime.now();
  TimeOfDay rescueTime = new TimeOfDay.now();
  String latitude = '';
  String longitude = '';
  String elevation = '';
  String elevationUnit = 'feet';
  String macroHabitat = "Plantation";
  String microHabitat = "Cow Shed";
  String condition = "Healthy";
  String length = '';
  String lengthUnit = 'feet';
  String weight = '';
  String weightUnit = "kg";
  String sex = "male";
  String subCaudal = 'Divided';
  int subCaudalVal = 70;
  String kcColor = 'Black';
  String behavior = 'docile';
  DateTime releaseDate;
  TimeOfDay releaseTime;
  String biteReport;
  String generalRemarks;
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
  List<String> _subCaudals = <String>['Divided', 'Undivided'];
  List<String> _kcColors = <String>['Black', 'Brown', 'Blackish Brown', 'Brownish Black', 'Olive Brown', 'Olive Green'];
  List<String> _lengthUnits = <String>['feet', 'metres'];
  List<String> _weightUnits = <String>['kg','lbs'];



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
          "pincode": int.parse(_data.pinCode),
          "country": "IN", //YTI
          "caller_name": _data.callerName,
          "caller_phone": int.parse(_data.phone),
          "snake_length": int.parse(_data.length),
          "snake_length_unit": _data.lengthUnit,
          "snake_weight": int.parse(_data.weight),
          "snake_weight_unit": _data.weightUnit,
          "snake_sex": _data.sex,
          "snake_color": _data.kcColor,
          "snake_divided_sub_caudals": _data.subCaudalVal,
          "snake_undivided_sub_caudals": _data.subCaudalVal,
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
                      this._data.pinCode = value;
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
                  title: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        width: 120.0,
                        child: new TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Latitude'
                          ),
                          onSaved: (value){
                            this._data.geoLocation['coordinates']['lat'] =  value;
                          },
                        ),
                      ),
                      new Container(
                        width: 120.0,
                        child: new TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Longitude'
                          ),
                          onSaved: (value){
                            this._data.geoLocation['coordinates']['lng'] =  value;
                          },
                        ),
                      )
                    ],
                  )
                ),

                new ListTile(
                  leading: const Icon(Icons.landscape),
                  title: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        width: 120.0,
                        child: new TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Elevation'
                          ),
                          onSaved: (value){
                            this._data.geoLocation['elevation']['value'] =  value;
                          },
                        ),
                      ),
                      new Container(
                        width:120.0,
                        child: new InputDecorator(
                          decoration: new InputDecoration(
                            labelText: "Unit"
                          ),
                          child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                  value: _data.elevationUnit,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _data.elevationUnit = newValue;
                                    });
                                  },
                                  items: _lengthUnits.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }
                                  ).toList()
                              )
                          ),
                        ),
                      )
                    ],
                  )
                ),

                new ListTile(
                    leading: const Icon(Icons.public),
                    title: new InputDecorator(
                      decoration: new InputDecoration(
                        labelText: "Macrohabitat"
                      ),
                      child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
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
                      )
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.home),
                    title: new InputDecorator(
                      decoration: new InputDecoration(
                        labelText: "Microhabitat"
                      ),
                      child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                              value: _data.microHabitat,
                              isDense: true,
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
                      )
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.local_hospital),
                    title: new InputDecorator(
                      decoration: new InputDecoration(
                        labelText: "Condition"
                      ),
                      child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                              value: _data.condition,
                              isDense: true,
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
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.compare_arrows),
                    title: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          width: 75.0,
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
                          width: 90.0,
                          child: new InputDecorator(
                            decoration: new InputDecoration(
                              labelText: "Unit"
                            ),
                            child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                    value: _data.lengthUnit,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _data.lengthUnit = newValue;
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
                      children: <Widget>[
                        new Container(
                          width: 75.0,
                          margin: const EdgeInsets.only(right: 40.0),
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
                          width: 90.0,
                          child: new InputDecorator(
                            decoration: new InputDecoration(
                              labelText: "Unit"
                            ),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                  value: _data.weightUnit,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _data.weightUnit = newValue;
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
                        )
                      ],
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.straighten),
                    title: new InputDecorator(
                      decoration: new InputDecoration(
                        labelText: "Sabcaudal"
                      ),
                      child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                              value: _data.subCaudal,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _data.subCaudal = newValue;
                                });
                              },
                              items: _subCaudals.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList()
                          )
                      ),
                    )
                ),

                new ListTile(
                    leading: new Padding(padding: EdgeInsets.only(right: 20.0)),
                    title: new TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        labelText: "#Subcaudals",
                      ),
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.palette),
                    title: new InputDecorator(
                      decoration: new InputDecoration(),
                      child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                              value: _data.kcColor,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _data.kcColor = newValue;
                                });
                              },
                              items: _kcColors.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList()
                          )
                      )
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.people),
                    title: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Radio<String>(
                          value: 'male',
                          groupValue: _data.sex,
                          activeColor: Colors.blue,
                          onChanged: (value){
                            setState(() {
                              _data.sex = value;
                            });
                          },
                        ),
                        new Text('Male'),
                        new Container(
                            width: 50.0,
                            height: 80.0
                        ),
                        new Radio<String>(
                          value: 'female',
                          groupValue: _data.sex,
                          onChanged: (value){
                            setState(() {
                              _data.sex = value;
                            });
                          },
                        ),
                        new Text('Female')
                      ],
                    )
                ),

                new ListTile(
                    leading: const Icon(Icons.security),
                    title: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Radio<String>(
                          value: 'docile',
                          groupValue: _data.behavior,
                          activeColor: Colors.blue,
                          onChanged: (value){
                            setState(() {
                              _data.behavior = value;
                            });
                          },
                        ),
                        new Text('Docile'),
                        new Container(
                            width: 38.0,
                        ),
                        new Radio<String>(
                          value: 'defensive',
                          groupValue: _data.behavior,
                          onChanged: (value){
                            setState(() {
                              _data.behavior = value;
                            });
                          },
                        ),
                        new Text('Defensive')
                      ],
                    )
                ),

                new Padding(
                  padding: EdgeInsets.only(left:20.0, right:20.0),
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'General Remarks'
                    ),
                  ),
                ),

                new Padding(
                  padding: EdgeInsets.only(left:20.0, right:20.0, top:10.0, bottom: 20.0),
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Bite Report'
                    ),
                  ),
                ),

                /*new ListTile(
                  leading: new IconButton(
                      icon: new Icon(Icons.photo_library),
                      onPressed: getImage
                  ),
                ),*/



                // Form Submit button
                new RaisedButton(
                  child: new Text(
                    'Submit',
                    style: new TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: this.submit,
                  color: Colors.blue
                )

              ],
            )
        )
    );
  }
}