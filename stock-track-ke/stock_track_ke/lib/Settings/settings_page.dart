import 'package:stock_track_ke/import/imports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isChangingDetails = false;
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
                  _isChangingDetails = true;
                });
              },
              child: Text('Change Details'),
            ),
            SizedBox(height: 20),
            if (_isChangingDetails)
              Column(
                children: [
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Type new password',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm new password',
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement change email functionality
                        },
                        child: Column(
                          children: [
                            Icon(Icons.email_sharp),
                            Text('Change Email'),
                          ],
                        ),
                      ),
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
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement change password functionality
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
