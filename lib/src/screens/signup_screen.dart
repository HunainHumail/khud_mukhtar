import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khud_mukhtar/src/screens/login_screen.dart';
import 'package:khud_mukhtar/src/screens/verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/user_model.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {

  final formkey = new GlobalKey<FormState>();
  String email;
  String password;
  String confirm_password;
  String signup_error;
  bool load = false;
  bool validate()
  {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    AssetImage logo = AssetImage('assets/logo.png');
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(child: Image(image: logo)),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 24, color: Color.fromRGBO(240, 98, 146, 1)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
                          child: Theme(
                            data: new ThemeData(
                                primaryColor: Color.fromRGBO(240, 98, 146, 1),
                                hintColor: Color.fromRGBO(248, 187, 208, 1)),
                            child: TextFormField(
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color.fromRGBO(248, 187, 208, 1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                hintText: "Email",
                                errorStyle: TextStyle(color: Colors.pink),
                              ),
                              validator: (value) => value.isEmpty ? "Please enter an email address" : null,
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
                          child: Theme(
                            data: new ThemeData(
                                primaryColor: Color.fromRGBO(240, 98, 146, 1),
                                hintColor: Color.fromRGBO(248, 187, 208, 1)),

                            child: TextFormField(
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Color.fromRGBO(248, 187, 208, 1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                hintText: "Password",
                                errorStyle: TextStyle(color: Colors.pink),

                              ),
                              obscureText: true,
                              validator: (value) => value.isEmpty ? "Please enter a password" : null,
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
                          child: Theme(
                            data: new ThemeData(
                                primaryColor: Color.fromRGBO(240, 98, 146, 1),
                                hintColor: Color.fromRGBO(248, 187, 208, 1)),
                            child: TextFormField(
                                onChanged: (value) {
                                  confirm_password= value;
                                },
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Color.fromRGBO(248, 187, 208, 1),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0)),
                                  hintText: "Confirm Password",
                                  errorStyle: TextStyle(color: Colors.pink),

                                ),
                                obscureText: true,
                                validator:  (value){
                                  if(value.isEmpty)
                                    return "Please confirm your password";
                                  if(value!= password)
                                    return 'Passwords do not match.';
                                  return null;
                                }
                            ),
                          )),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 50.0,
                                child:
                                ProgressButton(
                                  defaultWidget: const Text('Sign Up',
                                      textAlign: TextAlign.center, style:
                                      TextStyle(fontSize: 24, color: Colors.white)),
                                  progressWidget: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  width: 196,
                                  height: 40,
                                  animate: false,
                                  color: Color.fromRGBO(240, 98, 146, 1),
                                  borderRadius: 80,
                                  type: ProgressButtonType.Raised,
                                  onPressed: () async {
                                    if (validate())
                                    {
                                      setState(() {
                                        load = true;
                                      });
                                      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
                                          email: email, password: password).catchError((error){
                                        setState(() {
                                          signup_error = error.message.toString();
                                          load = false;
                                        });
                                      });
                                      if (load == false)
                                      {
                                        return;
                                      }
                                      FirebaseUser user = result.user;
                                      User newUser = User(id: user.uid,email: user.email);
                                      databaseReference.collection('Users').document(user.uid).setData(newUser.toMap());
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (BuildContext context) => Verification(currentUser: user,)));
                                    }
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return Login();
                                      }));
                                },
                                child: Text(
                                  'Already have an accout? Login',
                                  style: TextStyle(
                                      color: Color.fromRGBO(240, 98, 146, 1),
                                      fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),),
            ),
            showAlert(),
          ],
        )
      ),
    );
  }

  Widget showAlert() {
    if (signup_error != null) {
      return Container(
        color: Color.fromRGBO(240, 98, 146, 1),
        width: double.infinity,
        height : MediaQuery.of(context).size.height/11,
        padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Center(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error_outline, color: Colors.white),
              ),
              Expanded(
                child: AutoSizeText(
                  signup_error,
                  style: TextStyle(
                      color: Colors.white
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.close,
                    color: Colors.white,),
                  onPressed: () {
                    setState(() {
                      signup_error = null;
                    });
                  },
                ),
              )
            ],
          ),
        ),

      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
