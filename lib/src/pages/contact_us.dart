part of dozer;

class ContactUs extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: DrawerMain.mainDrawer(context),
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: new Padding(
          padding: EdgeInsets.all(0.0),
          child: Card(
            elevation: 3.0,
            margin: EdgeInsets.only(top:30.0, left:10.0, right:10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(height:10.0),

                Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/KF_Logo.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                  )
                ),

                SizedBox(height:20.0),
                
                ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.phone, color: Colors.blue),
                      onPressed: (){
                        launch("tel:+919480877670");
                      },
                    ),
                    title: Text("+91 94808 77670"),
                    subtitle: Text("MOBILE"),

                ),

                ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.mail, color: Colors.blue),
                      onPressed: (){
                        launch("mailto:ophiohannah2018@gmail.com?subject=App Query:");
                      },
                    ),
                    title: Text("ophiohannah2018@gmail.com"),
                    subtitle: Text("EMAIL")
                ),

                ListTile(
                    leading: IconButton(
                      icon: Icon(CustomIcons.facebook_1, color: Color.fromRGBO(59, 89, 152, 1.0)),
                      onPressed: (){
                        launch("https://www.facebook.com/KaalingaCRE");
                      },
                    ),
                    title: Text("https://www.facebook.com/KaalingaCRE"),
                    subtitle: Text("FACEBOOK"),
                ),

                ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.public, color: Colors.blue),
                      onPressed: (){
                        launch("http://kalingacre.com/");
                      },
                    ),
                    title: Text("http://kalingacre.com/"),
                    subtitle: Text("WEBSITE"),
                ),
              ],
            ),
          ),
      ),
    );
  }
}