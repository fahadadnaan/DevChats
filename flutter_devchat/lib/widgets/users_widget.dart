import 'package:flutter/material.dart';

class UsersWidget  {
 final List roomUsers ;
 final String room;
  UsersWidget({this.roomUsers, this.room});
  _bottomSheet(context) {
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
}
