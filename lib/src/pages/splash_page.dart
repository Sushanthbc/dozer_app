part of dozer;

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
      _auth.onAuthStateChanged
          .firstWhere((user) => user != null)
          .then((user) {
            print('From Firebase');
            print(user);
            UserInfo _newUserInfo = new UserInfo();
            _newUserInfo.name = user.displayName;
            _newUserInfo.phone = user.phoneNumber;
            _newUserInfo.email = user.email;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewUserForm(userInfo: _newUserInfo),
              ),
            );
        //Navigator.pushNamed(context, '/snakesList');
      });

      // Give the navigation animations, etc, some time to finish
      new Future.delayed(new Duration(seconds: 2))
        .then((_) => signInWithGoogle().then((onValue){
          //print(onValue);
      }));
    });


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/KC.jpg"),
            fit: BoxFit.fitHeight,
            alignment: Alignment.center
          ),
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
          new Text("Please wait...", style: new TextStyle(color: Colors.white),),
        ],
      ),
      )
    );
  }

}