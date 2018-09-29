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
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ListTile(
                leading: IconButton(
                    icon: Icon(Icons.phone, color: Colors.blue),
                    onPressed: (){
                      launch("tel:+919480877670");
                    },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Phone"),
                    Text("+91 9480877670"),
                  ],
                )
              ),

              ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.mail, color: Colors.blue),
                    onPressed: (){
                      launch("mailto:ophiohannah2018@gmail.com?subject=App Query:");
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Email"),
                      Text("ophiohannah2018@gmail.com"),
                    ],
                  )
              ),

              ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.public, color: Colors.blue),
                    onPressed: (){
                      launch("https://kalingacre.com/");
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Website"),
                      Text("kalingacre.com/"),
                    ],
                  )
              ),

            ],
          ),
      ),
    );
  }
}