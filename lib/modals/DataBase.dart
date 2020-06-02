import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  getUserByEmail(String email) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(usermap) {
    Firestore.instance.collection("users").add(usermap);
  }

  createChatroom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String email) async {
    var ref = await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: email);

    var querySnapshot = await ref.getDocuments();
    var total = querySnapshot.documents.length;

    if (total > 0) {
      return await ref.orderBy("lastUsed", descending: true).snapshots();
    } else {
      return await ref.snapshots();
    }
  }

  setChatRoom(String chatRoomId, lastUsed) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .updateData({"lastUsed": lastUsed}).catchError((e) {
      print(e);
    });
  }
}
