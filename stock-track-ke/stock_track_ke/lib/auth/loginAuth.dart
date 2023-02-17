import 'package:stock_track_ke/import/imports.dart';

class loginAuth {
  static Future<void> loginUserWithEmailAndPassword(
      String emailAddress, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login successful!'),
      ));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found, please try another email'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password provided!'),
          ),
        );
      }
    }
  }
}

/* class loginAuth {  static Future<void> loginUserWithEmailAndPassword(
      String emailAddress, String password, BuildContext context) async {
        try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailAddress,
    password: password
  );
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login successful!'),
      ));
  MyHomePage();
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not found, please try another email'),
      ));
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('wrong password provided!'),
      ));
  }
      }
  }
} */