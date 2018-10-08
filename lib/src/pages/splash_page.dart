part of dozer;

AppUserInfo _newUserInfo;
bool isNewUser = false;

class SplashPage extends StatefulWidget {
  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    new Timer(const Duration(seconds: 2), () {
      // Listen for our auth event (on reload or start)
      // Go to our /todos page once logged in
      _auth.onAuthStateChanged.firstWhere((user) => user != null).then(

        (user) {
          var checkUserReq = {
            "user" : {
              "email_id" : user.email
            }
          };
          http.post(
            globals.baseURL + "api/users/account_check",
            body: jsonEncode(checkUserReq),
            headers: {
              "accept": "application/json",
              "content-type": "application/json"
            }
          ).then((response){
            var resp = jsonDecode(response.body.toString());

            List<String> displayName = user.displayName.split(" ");
            _newUserInfo = new AppUserInfo();
            _newUserInfo.firstName = displayName[0];
            _newUserInfo.lastName = displayName[1];
            _newUserInfo.phone = user.phoneNumber;
            _newUserInfo.emailID = user.email;
            _newUserInfo.aboutUser = "Rescuer";
            isNewUser = true;
            setState(() {
            });

            /*if (resp["user"] == false) {

              List<String> displayName = user.displayName.split(" ");
              _newUserInfo = new AppUserInfo();
              _newUserInfo.firstName = displayName[0];
              _newUserInfo.lastName = displayName[1];
              _newUserInfo.phone = user.phoneNumber;
              _newUserInfo.emailID = user.email;
              _newUserInfo.aboutUser = "Rescuer";
              isNewUser = true;
              setState(() {
              });

            } else {
              SharedPref.setUserIdPref(resp["user"]["id"], resp["user"]["admin"]);
              SharedPref.getUserDetails().then((userDetails) {
                globals.loggedInUserId = resp["user"]["id"];
                globals.isUserAdmin = resp["user"]["admin"];
               Navigator.pushReplacementNamed(context, '/userSnakesList');
              });

            }*/
          }, onError: (err){
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Server error! Please try after sometime."))
            );
          });

      });

      // Give the navigation animations, etc, some time to finish
      new Future.delayed(new Duration(seconds: 2))
          .then((_) => signInWithGoogle().then((onValue) {
                //print(onValue);
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _checkNewUser(isNewUser)
    );
  }

  Widget _checkNewUser(isNewUser) {
    if (!isNewUser) {
      return new Container(
          constraints: new BoxConstraints.expand(
            height: double.infinity,
          ),
          padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/images/splash_kc.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.topCenter,
                child: new Padding(
                  padding: EdgeInsets.only(top:30.0),
                  child: new Text('Kalinga',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.white
                    ),
                  )
                ),
              ),
              new Positioned(
                left: 170.0,
                top: 80.0,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(),
                  ],
                ),
              ),
              new Positioned(
                right: 10.0,
                bottom: 50.0,
                child: new Image.asset(
                  "assets/images/KF_Logo.jpg",
                  fit: BoxFit.contain,
                  height: 100.0,
                ),
              ),
            ],
          )
      );
    } else {
      return UserRegistrationForm(userInfo: _newUserInfo);
    }
  }

}
