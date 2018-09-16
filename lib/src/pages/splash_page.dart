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
            "https://morning-castle-37512.herokuapp.com/api/users/account_check",
            body: jsonEncode(checkUserReq),
            headers: {
              "accept": "application/json",
              "content-type": "application/json"
            }
          ).then((response){
            var resp = jsonDecode(response.body.toString());
            if (resp["user"] == false) {
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
              Navigator.pushReplacementNamed(context, '/snakesList');
            }

          }, onError: (err){
            print('error checking first user');
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
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/images/KC.jpg"),
              fit: BoxFit.fitHeight,
              alignment: Alignment.center),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new SizedBox(height: 180.0),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
              ],
            ),
            new SizedBox(height: 20.0),
            new Text(
              "Please wait...",
              style: new TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return UserRegistrationForm(userInfo: _newUserInfo);
    }
  }

}
