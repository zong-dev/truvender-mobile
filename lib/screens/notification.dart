import 'package:flutter/material.dart';
import 'package:truvender/data/models/notify.dart';
import 'package:truvender/widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notify> notifications = [];
  bool loading = false;

  Widget buildView(){
    if(!loading && notifications.isNotEmpty){
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: notifications.length,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 8),
        itemBuilder: (context, index) {
            var notification = notifications[index];
            return NotificationTile(
              notification: notification,
            );
        },
      );
    }else if(loading){
       return const LoadingWidget();
    }else {
      return const EmptyData(text: "No notifications yet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: 'Notifications',
      child: SizedBox(
        child: Expanded(
          child: buildView(),
        ),
      )
    );
  }
}
