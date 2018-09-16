part of dozer;


class DrawerMain{

  static Widget mainDrawer(BuildContext context){
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            decoration: BoxDecoration(
              color: Colors.blue,
            ),

            child: Text(
              'Kalinga Foundation',
              style: new TextStyle(
                  color: Colors.white
              ),
            ),

          ),

          ListTile(
            leading: Icon(Icons.list),
            title: Text('My Records'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/snakesList');
              //Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/usersList');
              //
            },
          ),

          ListTile(
            leading: Icon(Icons.people),
            title: Text('Users'),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/usersList');
            },
          ),

          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Sign Out'),
          )


        ],
      ),
    );
  }

}