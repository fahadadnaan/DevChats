import 'package:flutter/material.dart';
import 'package:direct_select/direct_select.dart';

import 'chat_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _autoValidate = false;

  final _usernameController = TextEditingController();
  final _roomController = TextEditingController();

  final bool isForList = false;
  final rooms = [
    "JavaScript",
    "Python",
    "PHP",
    "C#",
    "Ruby",
    "Java"
  ];
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Dev Chats',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/chat.png'),
                Form(
                    key: _key,
                    autovalidate: _autoValidate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            controller: _usernameController,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: "Enter username",
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFA197E5), width: 0.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Color(0xFFEC5D4C), width: 1.0)),
                              suffixIcon:const Icon(
                                Icons.person,
                                color: Color(0xFFEC5D4C),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        DirectSelect(
                            itemExtent: 35.0,
                            selectedIndex: selectedIndex,
                            child:  SizedBox(
                              height: 60.0,
                              child: isForList
                                  ? Padding(
                                child: _buildItem(context),
                                padding: EdgeInsets.all(10.0),
                              )
                                  :  Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0.0),
                                child: TextFormField(
                                  controller: _roomController,
                                  enabled: false,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      // or any other color
                                    ),
                                    hintText: "Select room",
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFA197E5), width: 0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color(0xFFEC5D4C), width: 1.0)),
                                    suffixIcon: const Icon(
                                      Icons.chat,
                                      color: Color(0xFFEC5D4C),
                                    ),

                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Select the room';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedIndex = index;
                                _roomController.text = rooms[index];
                              });
                            },
                            mode: DirectSelectMode.tap,
                            items: _buildItems()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton(
                              onPressed: () {
                                if(_key.currentState.validate()) {
                                  Navigator.push(context,MaterialPageRoute(
                                      builder: (_) => ChatScreen(username: _usernameController.text, room: _roomController.text),
                                )
                                  );
                                }else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              child: Text('Join Room',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white),
                              ),
                              color:  Color(0xFFEC5D4C),
                            ),
                          ),
                        )
                      ],
                    )
                )
              ],
            )
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return rooms.map((val) => _buildItem(val)).toList();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Widget _buildItem( title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(title,style: TextStyle(fontSize: 15.0),)
      ),
    );
  }
}

