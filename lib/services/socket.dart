import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static String? baseUrl = dotenv.get('SOCKET_URL');

  SocketService();

  Future initialize() async {
    IO.Socket socket = IO.io(baseUrl);
    socket.onConnect((_) {
      socket.emit('msg', 'test');
    });
    return socket;
  }
}