part of dozer;

class UsersList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: DrawerMain.mainDrawer(context),
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: UsersListView()
    );
  }
}

class UsersListView extends StatefulWidget{
  @override
  UsersListViewState createState(){
    return UsersListViewState();
  }
}

class UsersListViewState extends State<UsersListView>{

  Future<List<AppUserInfo>> _getAppUsersList() async {
    final response = await http.get('https://morning-castle-37512.herokuapp.com/api/users');
    var responseJson = json.decode(response.body.toString());
    List<AppUserInfo> usersList = _createUserList(responseJson["users"]);
    return usersList;
  }

  List<AppUserInfo> _createUserList(List dataFromServer){
    List<AppUserInfo> list = new List();
    for (int i=0; i<dataFromServer.length; i++){
      AppUserInfo _userInfo = new AppUserInfo.fromMap(dataFromServer[i]);
      list.add(_userInfo);
    }
    return list;
  }

  IconData _getIconForAboutUser(String aboutUser){
    if (aboutUser == 'rescuer'){
      return Icons.brush;
    } else if (aboutUser == 'researcher'){
      return Icons.school;
    } else if (aboutUser == 'enthusiast'){
      return Icons.camera_alt;
    }
  }

  @override
  Widget build(BuildContext context) {

    return new FutureBuilder<List<AppUserInfo>>(
      future: _getAppUsersList(),
      builder: (context, snapshot){

        if (snapshot.hasData){

          return ListView.builder(
            itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(_getIconForAboutUser(snapshot.data[index].aboutUser)),
                      title: Text(snapshot.data[index].firstName + ' ' + snapshot.data[index].lastName),
                      subtitle: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text(snapshot.data[index].emailID),
                          Text(snapshot.data[index].phone)
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                );
              }
          );

        } else if (snapshot.hasError){

           return Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Icon(Icons.error_outline),
               Container(
                 margin: EdgeInsets.only(top: 10.0),
                 child: Text('Error fetching user'),
               )

             ],
           );

        } else {

          return CircularProgressIndicator();

        }

      }

    );
  }

}