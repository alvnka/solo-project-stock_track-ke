import 'package:stock_track_ke/import/imports.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Your Name"),
            accountEmail: Text("youremail@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "Y",
                style: TextStyle(fontSize: 40.0),
              ),
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
            leading: Icon(Icons.align_vertical_bottom),
            title: Text("Trading_symbols"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => TradingSymbolsPage())),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => Placeholder())),
              );
            },
          ),
        ],
      ),
    );
  }
}
