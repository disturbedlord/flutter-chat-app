import 'package:atg_chatapp/screens/feedPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;

  String email, password;
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 25,
                  maxWidth: MediaQuery.of(context).size.width),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "Chat_App",
                          style: GoogleFonts.pacifico(
                              fontSize: ScreenUtil().setSp(80.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: TextField(
                              onChanged: (v) {
                                email = v;
                              },
                              decoration: InputDecoration(
                                  labelText: "Email ID",
                                  prefixIcon: Icon(Icons.mail_outline),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                          ),
                          SizedBoxHeight(height: 40.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: TextField(
                              onChanged: (v) {
                                password = v;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBoxHeight(
                      height: 80,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        setState(() {
                          _showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);

                          if (user != null) {
                            Navigator.pushNamed(context, '/feed');
                          }

                          setState(() {
                            _showSpinner = false;
                          });
                        } catch (e) {
                          Toast.show("The credentials are Invalid", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                          setState(() {
                            _showSpinner = false;
                          });
                          print(e);
                        }
                      },
                      child: Icon(FontAwesomeIcons.arrowRight),
                      backgroundColor: Colors.black,
                    ),
                    SizedBoxHeight(
                      height: 80,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Center(
                        child: Container(
                          child: Text(
                            "Register",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 30.sp),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldLoginPage extends StatelessWidget {
  const TextFieldLoginPage({
    Key key,
    @required this.text,
    @required this.obs,
    @required this.icon,
  }) : super(key: key);
  final Icon icon;
  final String text;
  final int obs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextField(
        obscureText: obs == 1 ? true : false,
        decoration: InputDecoration(
            labelText: text,
            prefixIcon: icon,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }
}

class SizedBoxHeight extends StatelessWidget {
  const SizedBoxHeight({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(height),
    );
  }
}
