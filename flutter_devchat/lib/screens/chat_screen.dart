import 'dart:async';
import 'package:flutter/material.dart';
import 'package:DevChats/services/SocketService.dart';
import 'package:DevChats/widgets/message_widget.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String room;

  ChatScreen({Key key, this.username, this.room}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String get username => widget.username;
  String get room => widget.room;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SocketService socketService = injector.get<SocketService>();
  final TextEditingController _sendMessagesController = new TextEditingController();
  bool isWrote = false;
  bool isMe = false;
  String status = 'connecting...' ;
  List messages = new List();
  List roomUsers = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                key: UniqueKey(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMe = messages[index]['username'] == username;
                      return MessageWidget(message:messages[index], isMe: isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    initializeConnectionAndRoomDetails();
    roomDetails();
    checkSocketStatus();
    getMessages();
    onDisconnect();
  }

  @override
  void dispose() {
    _sendMessagesController.dispose();
    socketService.socket.dispose();
    super.dispose();
  }


  _buildAppBar(){
    return AppBar(
      title: Column(
        children: [
          Text(
            username,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(status,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      leading: IconButton(
        onPressed: () => socketService.socket.disconnect(),
        icon: Icon(Icons.backspace_outlined),
      ),
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.chat_outlined),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: ()=> _bottomSheet(),
        ),
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _sendMessagesController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                if(value.trim().isNotEmpty) {
                  setState(() {
                    isWrote = true;
                  });
                }else{
                  setState(() {
                    isWrote = false;
                  });
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: isWrote? Theme.of(context).primaryColor : Colors.grey,
            onPressed: () async {
              if(_sendMessagesController.text.trim().isNotEmpty){
                socketService.socket.emit('chatMessage', _sendMessagesController.text);
                _sendMessagesController.clear();
                setState(() {
                  isWrote = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

   _bottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child:  Column(
                    children: <Widget>[
                      Text('Current Users inside ${room.toString()}(${roomUsers.length.toString()})', style: TextStyle(fontSize: 18.0),),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 20,),
                        child:  Divider(),
                      ),
                     ListView.builder(
                       itemCount: roomUsers.length,
                         shrinkWrap: true,
                         itemBuilder: (context, index){
                         final String firstCharacter  = roomUsers[index]['username'][0];
                         final String lastCharacter  = roomUsers[index]['username'].substring(roomUsers[index]['username'].length - 1);
                           return Padding(
                             padding: EdgeInsets.symmetric(vertical: 5.0),
                             child:  ListTile(
                               selected: true,
                               selectedTileColor: Colors.green.shade50.withOpacity(0.3),
                               leading: CircleAvatar(
                                 radius: 25.0,
                                 child: Text(firstCharacter.toUpperCase()+lastCharacter.toUpperCase(), style: TextStyle(color: Colors.white),),
                                 backgroundColor: Colors.red,
                               ),
                               title: Text(roomUsers[index]['username'], textAlign: TextAlign.center,),
                             ),
                           );
                         }
                     ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  initializeConnectionAndRoomDetails(){
    socketService.createSocketConnection();
    socketService.socket.connect();
    socketService.onJoinRoom(username: username, room: room);
  }

  roomDetails(){
    socketService.onRoomUsers(roomUsers: roomUsers);
  }

  getMessages(){
    socketService.socket.on('message', (data) {
      setState(() {
        messages.insert(0, data);
      });
    });
  }

  checkSocketStatus(){
    socketService.socket.on("connect", (_) {
      setState(() {
        status = 'connected';
      });
    });
    socketService.socket.on("disconnect", (_) {
      setState(() {
        status = 'connecting...';
      });
    });
  }

  onDisconnect(){
   socketService.socket.on("disconnect", (_)  {
     _scaffoldKey.currentState.showSnackBar(SnackBar(
         content: Text('You are disconnected !!', textAlign: TextAlign.center,),
         backgroundColor: Theme.of(context).primaryColor,
         onVisible: ()=> Timer(Duration(seconds: 2), () => Navigator.pop(context)),
       ));
   });
  }
}
