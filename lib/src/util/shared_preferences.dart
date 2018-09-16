part of dozer;

class SharedPref{

  static setUserIdPref(int userId, bool isAdmin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
    prefs.setBool('isUserAdmin', isAdmin);
    //prefs.setInt('userId', 1);
    //prefs.setBool('isUserAdmin', false);
  }

  static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  static Future<bool> isUserAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUserAdmin');
  }

}