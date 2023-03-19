import 'package:stock_track_ke/Settings/settings_page.dart';
import 'package:stock_track_ke/import/imports.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _username = '';
  String _email = '';
  String? _profilePhotoUrl;
  bool _isChangingDetails = false;
  bool _changeUsername = false;
  bool _changePassword = false;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      setState(() {
        _username = userData.data()?['name'] ?? '';
        _email = userData.data()?['email'] ?? '';
        _profilePhotoUrl = userData.data()?['photoUrl'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$_username'),
            accountEmail: Text('$_email'),
            currentAccountPicture: CircleAvatar(
              radius: 50,
              backgroundImage: _profilePhotoUrl != null
                  ? NetworkImage(_profilePhotoUrl!)
                  : null,
              child: _profilePhotoUrl == null ? Icon(Icons.person) : null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => MyHomePage())),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text("Trading_symbols"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => TradingSymbolsPage())),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.track_changes_outlined),
            title: Text("Active tracks"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => ActiveTracksPage())),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => SettingsPage())),
              );
            },
          ),
        ],
      ),
    );
  }
}
