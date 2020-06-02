import 'dart:math';

import 'package:atg_chatapp/modals/DataBase.dart';
import 'package:atg_chatapp/screens/chatPage.dart';
import 'package:atg_chatapp/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  DataBase db = new DataBase();
  List<Color> col = [Colors.red, Colors.black, Colors.orange, Colors.yellow];
  var r = new Random();

  Stream chatRoomStream;

  Widget chatRoomWidget() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          if (snapshot.hasData == null) {
            setState(() {
              hadContacts = false;
            });
          }
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.documents[index].data["chatroomid"]
                            .toString()
                            .replaceAll(constants.myEmail, ""),
                        snapshot.data.documents[index].data["chatroomid"]
                            .toString());
                  })
              : Container();
        });
  }

  Color randomColor() {
    return col[r.nextInt(4)];
  }

  bool hadContacts = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        constants.myEmail = loggedInUser.email;
        db.getChatRooms(constants.myEmail).then((val) {
          setState(() {
            chatRoomStream = val;
            print(val.toString());
            if (val != null) hadContacts = true;
          });
        });
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text("Message",
            style: GoogleFonts.pacifico(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createGroup');
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 60.h,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(
              FontAwesomeIcons.search,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: hadContacts
            ? Container(
                child: chatRoomWidget(),
              )
            : Container(
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Add contacts using the",
                      style: TextStyle(fontSize: 30.sp),
                    ),
                    SizedBoxWidth(width: 10),
                    Icon(
                      FontAwesomeIcons.search,
                      size: 40.h,
                    ),
                  ],
                )),
              ),
      ),
    );
  }
}

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/chat");
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          height: 150.h,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 50.h,
                      child: Icon(FontAwesomeIcons.user),
                    ),
                    SizedBoxWidth(
                      width: 50.w,
                    ),
                    Text(
                      "Avinash Kumar E",
                      style: GoogleFonts.poppins(
                          fontSize: 32.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  height: 150.h,
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("3",
                          style: GoogleFonts.poppins(fontSize: 30.sp)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

class SizedBoxWidth extends StatelessWidget {
  const SizedBoxWidth({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().setWidth(width),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  ChatRoomTile(this.userName, this.chatRoom);
  final String userName;
  final String chatRoom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
                chatRoomId: chatRoom,
                chatPersonName: userName.split("@").length == 2
                    ? userName.replaceAll("_", "")
                    : userName.substring(0, userName.indexOf("_"))),
          ),
        );
      },
      child: Padding(
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 15.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 100.h,
                    width: 90.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text(
                      userName
                          .replaceAll("_", "")
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 50.sp),
                    ),
                  ),
                  SizedBoxWidth(width: 10),
                  Text(userName.split("@").length == 2
                      ? userName.replaceAll("_", "")
                      : userName.substring(0, userName.indexOf("_"))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
