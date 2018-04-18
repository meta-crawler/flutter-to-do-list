import 'package:flutter/material.dart';
import 'dummy_data.dart';

class ChatScreen extends StatelessWidget {
  var chatList = getDummyData();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
            backgroundColor: Colors.green,
            child: new Icon(
              Icons.message,
              color: Colors.white,
            ),
            onPressed: null),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              new ChatItem(chatList[index]),
          itemCount: chatList.length,
        ));
  }
}

class ChatItem extends StatelessWidget {
  final ChatModel _chatModel;

  ChatItem(this._chatModel);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new ListTile(
          leading: new CircleAvatar(
            backgroundImage: new NetworkImage(_chatModel.avatarUrl),
          ),
          title: new Padding(
            padding: const EdgeInsets.all(3.0),
            child: new Text(
              _chatModel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          subtitle: new Padding(
            padding: const EdgeInsets.all(3.0),
            child: new Text(
              _chatModel.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(fontSize: 16.0),
            ),
          ),
          trailing: new Text(_chatModel.time),
        ),
        new Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
