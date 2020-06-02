import 'package:atg_chatapp/modals/DataBase.dart';
import 'package:atg_chatapp/screens/chatPage.dart';
import 'package:atg_chatapp/screens/searchPage.dart';
import 'package:atg_chatapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController addPerson = new TextEditingController();
  TextEditingController groupName = new TextEditingController();

  List<String> people = [];

  createGroupChatRoom({email, people}) {
    List<String> users = [email, constants.myEmail];
    people.add(constants.myEmail);
    print("email");
    print(email);
    var chatRoomId = users[0] + users[1];

    Map<String, dynamic> chatRoomMap = {
      "users": people,
      "chatroomid": chatRoomId.toString(),
      "lastUsed": DateTime.now().millisecondsSinceEpoch
    };

    DataBase().createChatroom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  chatRoomId: chatRoomId,
                  chatPersonName: groupName.text,
                )));
  }

  groupChatRoom(String groupName, List<String> people) {
    people.sort();

    var kontan = StringBuffer();
    people.forEach((item) {
      kontan.write(item);
    });
    String str = kontan.toString();
    print(str);
    var groupChatRoomId = groupName + "_" + str;

    return groupChatRoomId.toString();
  }

  Widget peopleInGroup() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: people.length,
        itemBuilder: (context, index) {
          return PeopleTile(
            name: people[index],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Group",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 60.h,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                    text: "Group Name",
                    controller: groupName,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                    text: "Add a person",
                    controller: addPerson,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        print(addPerson.text);

                        people.add(addPerson.text);
                        addPerson.clear();
                        setState(() {});
                      },
                    )),
              ),
              Expanded(flex: 5, child: peopleInGroup()),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print(groupName.text);
                      createGroupChatRoom(
                          email: groupChatRoom(groupName.text, people),
                          people: people);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.h),
                          color: Colors.lightBlue),
                      child: Center(
                          child: Text(
                        "Create Group",
                        style: TextStyle(fontSize: 40.sp, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldInput extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final IconButton suffixIcon;
  TextFieldInput({this.text, this.controller, this.suffixIcon});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class PeopleTile extends StatelessWidget {
  final String name;
  PeopleTile({this.name});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: 30.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
