part of dozer;

// Create a Form Widget
class NewRescueForm extends StatefulWidget {
  //final String action;

  final SnakeInfo snakeInfo;

  NewRescueForm({Key key, @required this.snakeInfo}) : super(key: key);

  @override
  NewRescueFormState createState() {
    return NewRescueFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class NewRescueFormState extends State<NewRescueForm> {
  String httpAction;

  @override
  void initState() {
    if (widget.snakeInfo.id == null) {
      httpAction = "POST";
    } else {
      httpAction = "PUT";
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
      List<String> imagePath = image.path.split("/");
      print(imagePath[imagePath.length - 1]);
      widget.snakeInfo.images.add(image);
      widget.snakeInfo.imagesInfo
          .add({imagePath[imagePath.length - 1]: result});
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
  List<String> _latLngUnits = <String>[
    'Degrees Minutes Seconds',
    'Decimal Degrees'
  ];
  List<String> _directions = <String>['North', 'East', 'South', 'West'];
  String _latLngUnit = 'Decimal Degrees';
  String _latDir = "North";
  String _lngDir = "North";
  Map _dmsLat = {
    "degrees": null,
    "minutes": null,
    "seconds": null,
    "direction": null
  };
  Map _dmsLng = {
    "degrees": null,
    "minutes": null,
    "seconds": null,
    "direction": null
  };

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      httpInProgress = true;

      // Convert DMS LatLng to DD LatLng
      if (_dmsLat["degrees"] != null) {}

      // Check if images present in request
      if (widget.snakeInfo.images.length > 0) {
        upload(File imageFile) async {
          var uri = Uri.parse(globals.baseURL + "api/snake_charms");
          if (httpAction == "POST") {
            uri = Uri.parse(
                globals.baseURL + "api/snake_charms"
            );
          } else {
            uri = Uri.parse(
                globals.baseURL +
                "api/snake_charms/" +
                widget.snakeInfo.id.toString()
            );
          }
          var request = new http.MultipartRequest(httpAction, uri);
          request.headers["Accept"] = "application/json";
          request = SnakeInfo.getMultiPartFields(request, widget.snakeInfo);
          for (File image in widget.snakeInfo.images) {
            var file = await http.MultipartFile.fromPath(
              "snake_charm[snake_photos][]",
              image.path,
            );
            request.files.add(file);
          }
          request.send().then((response) {
            if (response.statusCode == 200) {
              response.stream.transform(utf8.decoder).listen((value) {
                httpInProgress = false;
                var resp = jsonDecode(value.toString());
                print(resp["snake_charm_details"]["id"]);
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: new Text("Rescue details saved!")));
              }, onError: (err) {
                httpInProgress = false;
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("Server Error. Please try again.")));
              });
            }
          }, onError: (err) {
            httpInProgress = false;
            Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Server Error. Please try again.")));
          });
        }

        ;
        upload(widget.snakeInfo.image);
      } else {
        var req = {"snake_charm": widget.snakeInfo.toMap()};
        if (httpAction == "POST") {
          http
              .post(globals.baseURL + "api/snake_charms",
                  headers: {
                    "accept": "application/json",
                    "content-type": "application/json"
                  },
                  body: jsonEncode(req))
              .then((response) {
            httpInProgress = false;
            if (response.statusCode == 200) {
              Navigator.pushReplacementNamed(context, "/userSnakesList");
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("New rescue details saved!")));
            }
          }, onError: (err) {
            Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Server Error. Please try after sometime.")));
          });
        } else {
          http
              .put(
                  globals.baseURL +
                      "api/snake_charms/" +
                      widget.snakeInfo.id.toString(),
                  headers: {
                    "accept": "application/json",
                    "content-type": "application/json"
                  },
                  body: jsonEncode(req))
              .then((response) {
            print(response.statusCode);
            if (response.statusCode == 200) {
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("Rescue details updated!")));
            }
          }, onError: (err) {
            Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Server error. Please try after sometime.")));
          });
        }
      }
    } else {
      // TODO validation message display
      print('validation failed');
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
      widget.snakeInfo.rescueDate = result;
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
      widget.snakeInfo.rescueTime = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return new Scaffold(
        appBar: AppBar(title: Text('Rescue Form')),
        drawer: DrawerMain.mainDrawer(context),
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
                              formatDate(widget.snakeInfo.rescueDate,
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
                              'Rescue Time: ${widget.snakeInfo.rescueTime.format(context)}'),
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
                          initialValue: widget.snakeInfo.callerName,
                          decoration:
                              new InputDecoration(labelText: 'Caller Name'),
                          onSaved: (value) {
                            widget.snakeInfo.callerName = value;
                          },
                        )),

                    new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new TextFormField(
                          initialValue: widget.snakeInfo.callerPhone,
                          keyboardType: TextInputType.phone,
                          decoration:
                              new InputDecoration(labelText: "Caller Phone"),
                          onSaved: (value) {
                            widget.snakeInfo.callerPhone = value;
                          },
                        )),

                    new ListTile(
                      leading: const Icon(Icons.location_on),
                      title: new TextFormField(
                        initialValue: widget.snakeInfo.address,
                        decoration: InputDecoration(labelText: 'Address'),
                        onSaved: (value) {
                          widget.snakeInfo.address = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: const Icon(Icons.local_post_office),
                      title: new TextFormField(
                        initialValue: widget.snakeInfo.pincode,
                        decoration: InputDecoration(labelText: 'Pincode'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          widget.snakeInfo.pincode = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: const Icon(Icons.location_city),
                      title: new TextFormField(
                        initialValue: widget.snakeInfo.village,
                        decoration: InputDecoration(labelText: 'Village/Town'),
                        onSaved: (value) {
                          widget.snakeInfo.village = value;
                        },
                      ),
                    ),

                    new ListTile(
                      leading: const Icon(Icons.location_on),
                      title: new InputDecorator(
                        decoration: new InputDecoration(
                            labelText: "Latitude Longitude Units"),
                        child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                                value: _latLngUnit,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _latLngUnit = newValue;
                                  });
                                },
                                items: _latLngUnits.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList())),
                      ),
                    ),

                    _latLngUnit == 'Degrees Minutes Seconds'
                        ? new Column(
                            children: <Widget>[
                              new ListTile(
                                  leading: new Padding(
                                      padding: EdgeInsets.only(left: 24.0)),
                                  title: new Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: new Text(
                                        'Latitude',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                  ),
                                  new Container(
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: false),
                                      decoration:
                                          InputDecoration(labelText: 'Degrees'),
                                      onSaved: (value) {
                                        _dmsLat["degrees"] = value;
                                      },
                                    ),
                                  ),
                                  new Container(
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: false),
                                      decoration:
                                          InputDecoration(labelText: 'Minutes'),
                                      onSaved: (value) {
                                        _dmsLat["minutes"] = value;
                                      },
                                    ),
                                  ),
                                  new Container(
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration:
                                          InputDecoration(labelText: 'Seconds'),
                                      onSaved: (value) {
                                        _dmsLat["seconds"] = value;
                                      },
                                    ),
                                  ),
                                  new Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          labelText: 'Direction'),
                                      onSaved: (value) {
                                        _dmsLat["seconds"] = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              new ListTile(
                                  leading: new Padding(
                                      padding: EdgeInsets.only(left: 24.0)),
                                  title: new Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: new Text('Longitude',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)))),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(left: 24.0),
                                  ),
                                  new Container(
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration:
                                          InputDecoration(labelText: 'Degrees'),
                                      onSaved: (value) {
                                        _dmsLng["degrees"] = value;
                                      },
                                    ),
                                  ),
                                  new Container(
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration:
                                          InputDecoration(labelText: 'Minutes'),
                                      onSaved: (value) {
                                        _dmsLng["minutes"] = value;
                                      },
                                    ),
                                  ),
                                  new Container(
                                    width: 80.0,
                                    child: new TextFormField(
                                      keyboardType:
                                          new TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration:
                                          InputDecoration(labelText: 'Seconds'),
                                      onSaved: (value) {
                                        _dmsLng["seconds"] = value;
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : new ListTile(
                            leading: new Padding(
                                padding: EdgeInsets.only(left: 24.0)),
                            title: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  width: 120.0,
                                  child: new TextFormField(
                                    initialValue:
                                        widget.snakeInfo.latitude.toString(),
                                    keyboardType:
                                        new TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration:
                                        InputDecoration(labelText: 'Latitude'),
                                    onSaved: (value) {
                                      widget.snakeInfo.latitude = value;
                                    },
                                  ),
                                ),
                                new Container(
                                  width: 120.0,
                                  child: new TextFormField(
                                    initialValue:
                                        widget.snakeInfo.longitude.toString(),
                                    keyboardType:
                                        new TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration:
                                        InputDecoration(labelText: 'Longitude'),
                                    onSaved: (value) {
                                      widget.snakeInfo.longitude = value;
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
                                initialValue:
                                    widget.snakeInfo.elevation.toString(),
                                keyboardType:
                                    new TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration:
                                    InputDecoration(labelText: 'Elevation'),
                                onSaved: (value) {
                                  widget.snakeInfo.elevation = value;
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
                                        value: widget.snakeInfo.elevationUnit,
                                        isDense: true,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            widget.snakeInfo.elevationUnit =
                                                newValue;
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
                                    value: widget.snakeInfo.macroHabitat,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        widget.snakeInfo.macroHabitat =
                                            newValue;
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
                                    value: widget.snakeInfo.microHabitat,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        widget.snakeInfo.microHabitat =
                                            newValue;
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
                                  value: widget.snakeInfo.snakeCondition,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      widget.snakeInfo.snakeCondition =
                                          newValue;
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
                                initialValue:
                                    widget.snakeInfo.snakeLength.toString(),
                                decoration: InputDecoration(
                                  labelText: 'Length',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value != "" &&
                                      double.parse(value) < 1.0) {
                                    return "Min : 1";
                                  } else if (value != "" &&
                                      double.parse(value) > 20.0) {
                                    return "Max : 15";
                                  }
                                },
                                onSaved: (value) {
                                  widget.snakeInfo.snakeLength = value;
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
                                        value: widget.snakeInfo.snakeLengthUnit,
                                        isDense: true,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            widget.snakeInfo.snakeLengthUnit =
                                                newValue;
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
                                initialValue:
                                    widget.snakeInfo.snakeWeight.toString(),
                                decoration: InputDecoration(
                                  labelText: 'Weight',
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) {
                                  if (value != "" &&
                                      double.parse(value) < 0.1) {
                                    return "Min : 0.1";
                                  } else if (value != "" &&
                                      double.parse(value) > 15.0) {
                                    return "Max : 15";
                                  }
                                },
                                onSaved: (value) {
                                  widget.snakeInfo.snakeWeight = value;
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
                                        value: widget.snakeInfo.snakeWeightUnit,
                                        isDense: true,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            widget.snakeInfo.snakeWeightUnit =
                                                newValue;
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
                          initialValue: widget.snakeInfo.dividedSubCaudals,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              labelText: "Divided",
                              hintText: "eg : 1-5,8-12,19-25"),
                          onSaved: (val) {
                            widget.snakeInfo.dividedSubCaudals = val;
                          },
                        )),

                    new ListTile(
                        leading:
                            new Padding(padding: EdgeInsets.only(right: 20.0)),
                        title: new TextFormField(
                          initialValue: widget.snakeInfo.undividedSubCaudals,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "Undivided",
                            hintText: "eg: 4-7,13-18,26-31",
                          ),
                          onSaved: (val) {
                            widget.snakeInfo.undividedSubCaudals = val;
                          },
                        )),

                    new ListTile(
                        leading: const Icon(Icons.palette),
                        title: new InputDecorator(
                            decoration: new InputDecoration(labelText: "Color"),
                            child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                    value: widget.snakeInfo.snakeColor,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        widget.snakeInfo.snakeColor = newValue;
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
                              groupValue: widget.snakeInfo.snakeSex,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  widget.snakeInfo.snakeSex = value;
                                });
                              },
                            ),
                            new Text('Male'),
                            new Container(width: 50.0, height: 80.0),
                            new Radio<String>(
                              value: 'female',
                              groupValue: widget.snakeInfo.snakeSex,
                              onChanged: (value) {
                                setState(() {
                                  widget.snakeInfo.snakeSex = value;
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
                              groupValue: widget.snakeInfo.snakeBehavior,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  widget.snakeInfo.snakeBehavior = value;
                                });
                              },
                            ),
                            new Text('Docile'),
                            new Container(
                              width: 38.0,
                            ),
                            new Radio<String>(
                              value: 'defensive',
                              groupValue: widget.snakeInfo.snakeBehavior,
                              onChanged: (value) {
                                setState(() {
                                  widget.snakeInfo.snakeBehavior = value;
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

                    widget.snakeInfo.snakePhotos.length > 0
                        ? new GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: List.generate(
                                snakeInfo.snakePhotos.length, (index) {
                              return Center(
                                  child: new Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KcImageViewer(
                                                imageURL: snakeInfo
                                                    .snakePhotos[index],
                                              ),
                                        ),
                                      );
                                    },
                                    child: new Image.network(
                                      snakeInfo.snakePhotos[index],
                                    ),
                                  ),
                                ],
                              ));
                            }))
                        : new Container(),

                    new ListTile(
                        leading: null,
                        title: new FlatButton(
                          onPressed: getImage,
                          child: Text(
                            'Attach Photo',
                            style: new TextStyle(
                                color: Colors.blue, fontSize: 18.0),
                          ),
                        )),

                    widget.snakeInfo.images.length > 0
                        ? new GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: List.generate(
                                widget.snakeInfo.images.length, (index) {
                              return Center(
                                  child: new Column(
                                children: <Widget>[
                                  new Image.file(
                                      widget.snakeInfo.images[index]),
                                  //new Text(widget.snakeInfo.imagesInfo[index]['image'])
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
