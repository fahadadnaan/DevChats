import 'package:DevChats/utls/socket_server.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meta/meta.dart';

class SocketService {
  IO.Socket socket;
  static String serverUrl = SocketServer.url;

  createSocketConnection() {
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
    });
    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }

  onJoinRoom({@required username, @required room}){
    socket.emit('joinRoom', {'username': username, 'room': room});
  }

  onRoomUsers({@required List roomUsers}){
    socket.on('roomUsers', (data) {
      if(roomUsers.isNotEmpty) roomUsers.clear();
      roomUsers.addAll(data['users']);
    });
  }

}