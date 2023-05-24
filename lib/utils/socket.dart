import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:truvender/blocs/app/app_bloc.dart';

socketHandler(IO.Socket socket, BuildContext context) async {
  socket.onConnect((_) {
    print('connected');
    socket.emit('msg', 'test');
  });
  socket.on('newNotifcation', (data) {
    BlocProvider.of<AppBloc>(context).localNotificationService.showNotification(
        body: data['data']['message'],
        title: data['data']['title'],
        id: data['id']);
  });
  // socket.onDisconnect((_) => print('disconnect'));
  // socket.on('fromServer', (_) => print(_));
}
