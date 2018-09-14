part of dozer;

// Create a Form Widget
class NewRescueForm extends StatefulWidget {
  final String action;

  NewRescueForm({Key key, @required this.action}) : super(key: key);

  @override
  NewRescueFormState createState() {
    return NewRescueFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class NewRescueFormState extends State<NewRescueForm> {
  SnakeInfo _data;

  @override
  void initState() {
    if (widget.action == 'create') {
      _data = new SnakeInfo(
          rescueDate: new DateTime.now(),
          rescueTime: new TimeOfDay.now(),
          snakeCondition: 'Healthy',
          snakeSex: 'male',
          snakeBehavior: 'docile',
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
          imagesInfo: []);
    }

    super.initState();
  }

  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  bool httpInProgress = false;

  String imageInfo;

  // Image picker
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final Map result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SnakeImageInfo(snakePhoto: image)),
    );
    setState(() {
      _data.images.add(image);
      _data.imagesInfo
          .add({"snake_photo_" + (_data.images.length - 1).toString(): result});
    });
  }

  List<String> _macroHabitats = <String>[
    'House',
    'Plantation',
    'Agricultural Field',
    'Forest'
  ];
  List<String> _microHabitats = <String>[
    'Bedroom',
    'Kitchen',
    'Hall',
    'Bathroom',
    'Cow Shed'
  ];
  List<String> _conditions = <String>['Healthy', 'Weak', 'Shedding'];
  List<String> _kcColors = <String>[
    'Black',
    'Brown',
    'Blackish Brown',
    'Brownish Black',
    'Olive Brown',
    'Olive Green'
  ];
  List<String> _lengthUnits = <String>['Feet', 'Metres'];
  List<String> _weightUnits = <String>['Kg', 'Lbs'];

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      httpInProgress = true;

      // Check if images present in request
      if (_data.images.length > 0) {
        upload(File imageFile) async {
          var uri = Uri.parse(
              "https://morning-castle-37512.herokuapp.com/api/snake_charms");
          var request = new http.MultipartRequest("POST", uri);
          request = SnakeInfo.getMultiPartFields(request, _data);
          for (File image in _data.images) {
            var file = await http.MultipartFile.fromPath(
              "snake_charm[snake_photo]",
              image.path,
            );
            request.files.add(file);
          }
          request.send().then((response) {
            if (response.statusCode == 200) {
              httpInProgress = false;
              new SnackBar(content: new Text("New rescue details saved!"));
              Navigator.pop(context);
            }
          });
        };
        upload(_data.image);
      } else {
        var req = {"snake_charm": _data.toMap()};
        http
            .post("https://morning-castle-37512.herokuapp.com/api/snake_charms",
            headers: {
              "accept": "application/json",
              "content-type": "application/json"
            },
            body: jsonEncode(req))
            .then((response) {
          httpInProgress = false;
          if (response.statusCode == 200) {
            new SnackBar(content: new Text("New rescue details saved!"));
            Navigator.pop(context);
          }
        });
      }
    } else {
      // TODO validation message display
    }
  }

  Future<DateTime> _chooseDate(
      BuildContext context, DateTime initialDate) async {
    var now = new DateTime.now();
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

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

  Future<TimeOfDay> _chooseTime(
      BuildContext context, TimeOfDay initialTime) async {
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
    return new Scaffold(
        appBar: AppBar(title: Text('asdf')),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    new ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text('Rescue Date: ' +
                              formatDate(_data.rescueDate,
                                  ['dd', '-', 'mm', '-', 'yyyy'])),
                          new IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () =>
                                  _chooseDate(context, new DateTime.now()))
                        ],
                      ),
                    ),

                    new ListTile(
                      leading: const Icon(Icons.timer),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                              'Rescue Time: ${_data.rescueTime.format(context)}'),
                          new IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () =>
                                  _chooseTime(context, new TimeOfDay.now()))
                        ],
                      ),
                    ),

                    new ListTile(
                        leading: const Icon(Icons.person),
                        title: new TextFormField(
                          initialValue: _data.callerName,
                          decoration:
                          new InputDecoration(labelText: 'Caller Name'),
                          onSaved: (value) {
                            _data.callerName = value;
                          },
                        )),

                    new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new TextFormField(
                          initialValue: _data.callerPhone,
                          decoration:
                          new InputDecoration(labelText: "Caller Phone"),
                          onSaved: (value) {
                            _data.callerPhone = value;
                          },
                        )),

                    new ListTile(
                      leading: const Icon(Icons.location_on),
                      title: new TextFormField(
                        initialValue: _data.address,
                        decoration: InputDecoration(labelText: 'Address'),
                        onSaved: (value) {
                          _data.address = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: const Icon(Icons.local_post_office),
                      title: new TextFormField(
                        initialValue: _data.pincode,
                        decoration: InputDecoration(labelText: 'Pincode'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _data.pincode = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: const Icon(Icons.location_city),
                      title: new TextFormField(
                        initialValue: _data.village,
                        decoration: InputDecoration(labelText: 'Village/Town'),
                        onSaved: (value) {
                          _data.village = value;
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
                                initialValue: _data.latitude.toString(),
                                keyboardType:
                                new TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration:
                                InputDecoration(labelText: 'Latitude'),
                                onSaved: (value) {
                                  _data.latitude = value;
                                },
                              ),
                            ),
                            new Container(
                              width: 120.0,
                              child: new TextFormField(
                                initialValue: _data.longitude.toString(),
                                keyboardType:
                                new TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration:
                                InputDecoration(labelText: 'Longitude'),
                                onSaved: (value) {
                                  _data.longitude = value;
                                },
                              ),
                            )
                          ],
                        )),

                    new ListTile(
                        leading: const Icon(Icons.landscape),
                        title: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              width: 120.0,
                              child: new TextFormField(
                                initialValue: _data.elevation.toString(),
                                keyboardType:
                                new TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration:
                                InputDecoration(labelText: 'Elevation'),
                                onSaved: (value) {
                                  _data.elevation = value;
                                },
                              ),
                            ),
                            new Container(
                              width: 120.0,
                              child: new InputDecorator(
                                decoration:
                                new InputDecoration(labelText: "Unit"),
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
                                        }).toList())),
                              ),
                            )
                          ],
                        )),

                    new ListTile(
                        leading: const Icon(Icons.public),
                        title: new InputDecorator(
                            decoration:
                            new InputDecoration(labelText: "Macrohabitat"),
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
                                    }).toList())))),

                    new ListTile(
                        leading: const Icon(Icons.home),
                        title: new InputDecorator(
                            decoration:
                            new InputDecoration(labelText: "Microhabitat"),
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
                                    }).toList())))),

                    new ListTile(
                        leading: const Icon(Icons.local_hospital),
                        title: new InputDecorator(
                          decoration:
                          new InputDecoration(labelText: "Condition"),
                          child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                  value: _data.snakeCondition,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _data.snakeCondition = newValue;
                                    });
                                  },
                                  items: _conditions.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList())),
                        )),

                    new ListTile(
                        leading: const Icon(Icons.compare_arrows),
                        title: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              width: 75.0,
                              child: new TextFormField(
                                initialValue: _data.snakeLength.toString(),
                                decoration: InputDecoration(
                                  labelText: 'Length',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  _data.snakeLength = value;
                                },
                              ),
                            ),
                            new Container(
                              width: 90.0,
                              child: new InputDecorator(
                                decoration:
                                new InputDecoration(labelText: "Unit"),
                                child: new DropdownButtonHideUnderline(
                                    child: new DropdownButton<String>(
                                        value: _data.snakeLengthUnit,
                                        isDense: true,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _data.snakeLengthUnit = newValue;
                                          });
                                        },
                                        items: _lengthUnits.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList())),
                              ),
                            )
                          ],
                        )),

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
                                initialValue: _data.snakeWeight.toString(),
                                decoration: InputDecoration(
                                  labelText: 'Weight',
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onSaved: (value) {
                                  _data.snakeWeight = value;
                                },
                              ),
                            ),
                            new Container(
                                width: 90.0,
                                child: new InputDecorator(
                                  decoration:
                                  new InputDecoration(labelText: "Unit"),
                                  child: new DropdownButtonHideUnderline(
                                    child: new DropdownButton<String>(
                                        value: _data.snakeWeightUnit,
                                        isDense: true,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _data.snakeWeightUnit = newValue;
                                          });
                                        },
                                        items: _weightUnits.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList()),
                                  ),
                                ))
                          ],
                        )),

                    new ListTile(
                        leading: const Icon(Icons.straighten),
                        title: new Text('Subcaudals:')),

                    new ListTile(
                        leading:
                        new Padding(padding: EdgeInsets.only(right: 20.0)),
                        title: new TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              labelText: "Divided",
                              hintText: "eg : 1-5,8-12,19-25"),
                          onSaved: (val){
                            _data.dividedSubCaudals  = val;
                          },
                        )),

                    new ListTile(
                        leading:
                        new Padding(padding: EdgeInsets.only(right: 20.0)),
                        title: new TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "Undivided",
                            hintText: "eg: 4-7,13-18,26-31",
                          ),
                          onSaved: (val){
                            _data.undividedSubCaudals = val;
                          },
                        )),

                    new ListTile(
                        leading: const Icon(Icons.palette),
                        title: new InputDecorator(
                            decoration: new InputDecoration(),
                            child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                    value: _data.snakeColor,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _data.snakeColor = newValue;
                                      });
                                    },
                                    items: _kcColors.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList())))),

                    new ListTile(
                        leading: const Icon(Icons.people),
                        title: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Radio<String>(
                              value: 'male',
                              groupValue: _data.snakeSex,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _data.snakeSex = value;
                                });
                              },
                            ),
                            new Text('Male'),
                            new Container(width: 50.0, height: 80.0),
                            new Radio<String>(
                              value: 'female',
                              groupValue: _data.snakeSex,
                              onChanged: (value) {
                                setState(() {
                                  _data.snakeSex = value;
                                });
                              },
                            ),
                            new Text('Female')
                          ],
                        )),

                    new ListTile(
                        leading: const Icon(Icons.security),
                        title: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Radio<String>(
                              value: 'docile',
                              groupValue: _data.snakeBehavior,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _data.snakeBehavior = value;
                                });
                              },
                            ),
                            new Text('Docile'),
                            new Container(
                              width: 38.0,
                            ),
                            new Radio<String>(
                              value: 'defensive',
                              groupValue: _data.snakeBehavior,
                              onChanged: (value) {
                                setState(() {
                                  _data.snakeBehavior = value;
                                });
                              },
                            ),
                            new Text('Defensive')
                          ],
                        )),

                    new Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new TextFormField(
                        decoration:
                        new InputDecoration(labelText: 'General Remarks'),
                      ),
                    ),

                    new Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                      child: new TextFormField(
                        decoration:
                        new InputDecoration(labelText: 'Bite Report'),
                      ),
                    ),

                    new ListTile(
                      leading: new IconButton(
                          icon: new Icon(Icons.photo_library),
                          onPressed: getImage),
                    ),

                    _data.images.length > 0
                        ? new GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children:
                        List.generate(_data.images.length, (index) {
                          return Center(
                              child: new Column(
                                children: <Widget>[
                                  new Image.file(_data.images[index]),
                                  //new Text(_data.imagesInfo[index]['image'])
                                ],
                              ));
                        }))
                        : new Container(),

                    // Form Submit button
                    new RaisedButton(
                        child: new Text(
                          'Submit',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: this.submit,
                        color: Colors.blue)
                  ],
                ))));
  }
}
