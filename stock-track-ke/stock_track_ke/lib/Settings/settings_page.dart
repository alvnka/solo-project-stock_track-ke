import 'package:stock_track_ke/import/imports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isChangingDetails = false;
  bool _changeUsername = false;
  bool _changePassword = false;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Username: johndoe',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Email: johndoe@example.com',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isChangingDetails = !_isChangingDetails;
                });
              },
              child: Text('Change Details'),
            ),
            SizedBox(height: 20),
            if (_isChangingDetails)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement change username functionality
                        },
                        child: Column(
                          children: [
                            Icon(Icons.person),
                            Text('Change Username'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _changePassword = !_changePassword;
                              });
                            },
                            child: Column(
                              children: [
                                Icon(Icons.key_sharp),
                                Text('Change Password'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement delete account functionality
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.delete),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
