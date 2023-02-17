import 'package:stock_track_ke/import/imports.dart';

class signUpAuth {
  static Future<void> createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Account created successfully!'),
      ));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}
/* class Auth {
Future<void> SignUpAuth(String emailAddress, String password) async {
  try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    context.callMethod('alert', ['Registration successful']);
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(
        msg: 'The password provided is too weak.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.redAccent,
        fontSize: 16.0,
      );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(
        msg: 'The account already exists for that email.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.redAccent,
        fontSize: 16.0,
      );
      }
    } catch (e) {
        print(e);
  }
}
} */