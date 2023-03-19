import 'package:stock_track_ke/import/imports.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _currentPasswordError = '';
  String _confirmPasswordError = '';
  bool _currentPasswordObscure = true;
  bool _newPasswordObscure = true;
  bool _confirmPasswordObscure = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _currentPasswordController.text,
          );
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(_newPasswordController.text);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _currentPasswordError = 'Incorrect password';
        });
      }
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: _currentPasswordObscure,
              decoration: InputDecoration(
                hintText: 'Current Password',
                errorText: _currentPasswordError,
                errorBorder: _currentPasswordError.isNotEmpty
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )
                    : OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                suffixIcon: IconButton(
                  icon: Icon(_currentPasswordObscure
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _currentPasswordObscure = !_currentPasswordObscure;
                    });
                  },
                ),
              ),
            ),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _newPasswordObscure,
              decoration: InputDecoration(
                hintText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(_newPasswordObscure
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _newPasswordObscure = !_newPasswordObscure;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a new password';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _confirmPasswordObscure,
              decoration: InputDecoration(
                hintText: 'Confirm New Password',
                errorText: _confirmPasswordError,
                errorBorder: _confirmPasswordError.isNotEmpty
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )
                    : InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(_confirmPasswordObscure
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordObscure = !_confirmPasswordObscure;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm the new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _handleCancel,
          child: Text('Cancel'),
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
        ),
        ElevatedButton(
          onPressed: _handleChangePassword,
          child: Text('Save'),
        ),
      ],
    );
  }
}

void showChangePasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ChangePasswordDialog(),
  );
}
