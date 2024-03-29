import 'package:stock_track_ke/import/imports.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email here',
                    suffixIcon: Icon(Icons.email)),
              ),
            ),
            Container(
              width: 400,
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: passwordController,
                obscureText: _obscureText,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm your password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  loginAuth.loginUserWithEmailAndPassword(
                      emailController.text, passwordController.text, context);
                  print("pressed");
                },
                child: Text("Login"),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 101, 174, 235)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {

/*               setState(() {
                _isSigningIn = true;
              });

              // TODO: Add method call to the Google Sign-In authentication

              setState(() {
                _isSigningIn = false;
              }); */
                loginAuth.logInWithGoogle(context);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/logo/google_logo.jpg"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Log in with Google',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 600,
              child: Divider(
                color: Colors.grey[300],
                thickness: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Don't have an account?"),
                  InkWell(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => signUpScreen()),
                      );
                    },
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
