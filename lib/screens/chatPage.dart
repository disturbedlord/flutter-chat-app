import 'package:atg_chatapp/modals/DataBase.dart';
import 'package:atg_chatapp/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String chatPersonName;
  ChatPage({this.chatRoomId, this.chatPersonName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = new TextEditingController();
  DataBase db = new DataBase();
  String message;

  Stream chatMessageStream;

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data["message"],
                        snapshot.data.documents[index].data["sendBy"] ==
                            constants.myEmail);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": constants.myEmail,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      db.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.clear();
    }
  }

  @override
  void initState() {
    db.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatPersonName,
          style: GoogleFonts.pacifico(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: "Type a message",
                    hasFloatingPlaceholder: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Icon(Icons.send)),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            decoration: BoxDecoration(
                color: isSendByMe ? Colors.greenAccent : Colors.black54,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft:
                        isSendByMe ? Radius.circular(15) : Radius.circular(0),
                    bottomRight:
                        isSendByMe ? Radius.circular(0) : Radius.circular(15))
                // border: Border.fromBorderSide()
                ),
            child: Text(
              message,
              style: TextStyle(fontSize: 30.sp, color: Colors.black),
            )),
      ),
    );
  }
}
