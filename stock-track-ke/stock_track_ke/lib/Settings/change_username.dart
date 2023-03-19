import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeUsernameDialog extends StatefulWidget {
  const ChangeUsernameDialog({Key? key}) : super(key: key);

  @override
  ChangeUsernameDialogState createState() => ChangeUsernameDialogState();
}

class ChangeUsernameDialogState extends State<ChangeUsernameDialog> {
  final TextEditingController _newUsernameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _updateUsername(String newUsername) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final userDocSnap = await userDoc.get();
      if (!userDocSnap.exists) {
        // Create new document with initial details
        await userDoc.set({
          'name': newUsername,
          'email': user.email,
          'photoUrl': user.photoURL,
        });
      } else {
        // Update existing document
        await userDoc.update({'name': newUsername});
      }
      setState(() {});
    }
  }

  Future<void> showChangeUsernameDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _newUsernameController,
                  decoration: const InputDecoration(
                    labelText: 'New Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new username';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _updateUsername(_newUsernameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showChangeUsernameDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/*class ChangeUsernameDialog extends StatefulWidget {
  const ChangeUsernameDialog({Key? key}) : super(key: key);

  @override
  ChangeUsernameDialogState createState() => ChangeUsernameDialogState();

}

class ChangeUsernameDialogState extends State<ChangeUsernameDialog> {
  final TextEditingController _newUsernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _updateUsername(String newUsername) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final userDocSnap = await userDoc.get();
      if (!userDocSnap.exists) {
        // Create new document with initial details
        await userDoc.set({
          'name': newUsername,
          'email': user.email,
          'photoUrl': user.photoURL,
        });
      } else {
        // Update existing document
        await userDoc.update({'name': newUsername});
      }
      setState(() {});
    }
  }

  Future<void> showChangeUsernameDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _newUsernameController,
                  decoration: const InputDecoration(
                    labelText: 'New Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new username';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _updateUsername(_newUsernameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showChangeUsernameDialog();
      },
      child: const Text('Change Username'),
    );
  }
}
 */