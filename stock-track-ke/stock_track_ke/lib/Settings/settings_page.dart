import 'package:stock_track_ke/import/imports.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
/* import 'package:web_image_picker/web_image_picker.dart'
    if (kIsWeb) 'package:web_image_picker/web_image_picker.dart'; */

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        _profilePhotoUrl = userData.data()?['photoUrl'];
      });
    }
  }

/* Future<void> _changeProfilePhoto() async {
  final picker = kIsWeb ? WebImagePickerController() : ImagePicker();
  XFile? pickedFile;
  if (picker is ImagePicker) {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
  } else if (picker is WebImagePickerController) {
    pickedFile = await (picker.getImage() as XFile?);
  }
  if (pickedFile != null) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('Users/${user.uid}.jpg');
      final uploadTask = storageRef.putFile(File(pickedFile.path));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'profile_photo_url': downloadUrl});
      setState(() {
        _profilePhotoUrl = downloadUrl;
      });
    }
  }
} */

  Future<void> _changeProfilePhoto() async {
    final picker = ImagePicker();
    XFile? pickedFile;
    if (picker is ImagePicker) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } /*  else if (picker is WebImagePickerController) {
    pickedFile = await (picker.getImage() as XFile?);
  } */
    if (pickedFile != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('Users/${user.uid}.jpg');
        final uploadTask = storageRef.putFile(File(pickedFile.path));
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'profile_photo_url': downloadUrl});
        setState(() {
          _profilePhotoUrl = downloadUrl;
        });
      }
    }
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
            Stack(
              children: [
                GestureDetector(
                  onTap: _changeProfilePhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profilePhotoUrl != null
                        ? NetworkImage(_profilePhotoUrl!)
                        : null,
                    child: _profilePhotoUrl == null ? Icon(Icons.person) : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeProfilePhoto,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Username: $_username',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Email: $_email',
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChangeUsernameDialog();
                            },
                          );
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ChangePasswordDialog();
                                },
                              );
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
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => loginPage()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.logout_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
