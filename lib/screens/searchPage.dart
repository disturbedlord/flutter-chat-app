import 'package:atg_chatapp/modals/DataBase.dart';
import 'package:atg_chatapp/screens/chatPage.dart';
import 'package:atg_chatapp/screens/feedPage.dart';
import 'package:atg_chatapp/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Searchpage extends StatefulWidget {
  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  DataBase db = new DataBase();
  String email;
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return SearchTile(
                email: searchSnapshot.documents[index].data["email"],
                name: searchSnapshot.documents[index].data["name"],
              );
            })
        : Container();
  }

  initiateSearch() {
    print(email);
    db.getUserByEmail(email).then((val) {
      print("called");
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatroomAndStartConversation({String email}) {
    if (email != constants.myEmail) {
      List<String> users = [email, constants.myEmail];

      String chatRoomId = getChatRoomId(users[0], users[1]);

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId,
        "lastUsed": DateTime.now().millisecondsSinceEpoch,
      };

      DataBase().createChatroom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    chatRoomId: chatRoomId,
                    chatPersonName: chatRoomId
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(constants.myEmail, ""),
                  )));
    } else {
      print("Not Found/Searching yourself");
    }
  }

  Widget SearchTile({String email, String name}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: simpleTextStyle()),
                  SizedBoxHeight(
                    height: 10,
                  ),
                  Text(
                    email,
                    style: simpleTextStyle(),
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  createChatroomAndStartConversation(email: email);
                },
                icon: Icon(
                  FontAwesomeIcons.commentDots,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Search Members",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 30.h, bottom: 20.h),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: TextField(
                    onChanged: (v) {
                      email = v;
                    },
                    decoration: InputDecoration(
                        labelText: "Search for contacts",
                        prefixIcon: Icon(FontAwesomeIcons.users),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            initiateSearch();
                          },
                          icon: Icon(FontAwesomeIcons.search),
                        )),
                  ),
                ),
              ),
              SizedBoxHeight(height: 20),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle simpleTextStyle() => TextStyle(fontSize: 30.sp, color: Colors.black);

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
