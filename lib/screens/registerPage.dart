import 'package:atg_chatapp/modals/DataBase.dart';
import 'package:atg_chatapp/screens/feedPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;

  DataBase db = new DataBase();

  int obs = 0;
  String email, password, name;
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80.h),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: TextField(
                      onChanged: (v) {
                        name = v;
                      },
                      decoration: InputDecoration(
                          labelText: "Name",
                          prefixIcon: Icon(FontAwesomeIcons.user),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
                SizedBoxHeight(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: TextField(
                    onChanged: (v) {
                      email = v;
                    },
                    decoration: InputDecoration(
                        labelText: "Email ID",
                        prefixIcon: Icon(Icons.mail_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                SizedBoxHeight(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: TextField(
                    onChanged: (v) {
                      password = v;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                SizedBoxHeight(
                  height: 80,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      if (newUser != null) {
                        db.uploadUserInfo({
                          "name": name,
                          "email": email,
                        });
                        Navigator.pushNamed(context, '/feed');
                      }
                    } catch (e) {
                      print(e);
                      Toast.show("Already Exist/Badly formatted", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                    setState(() {
                      _showSpinner = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 30.h, left: 50.w, right: 50.w, bottom: 30.h),
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 35.sp),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
