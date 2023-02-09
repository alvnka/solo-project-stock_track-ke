import 'package:stock_track_ke/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email here'
                ),
              ),
            ),

            Container(
              width: 400,
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your password'
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(onPressed: (){
                Placeholder();
                print("pressed");
              },
                child: Text("Login"),
              ),
            )
        ],
        ),
        ),
    );
  }
}