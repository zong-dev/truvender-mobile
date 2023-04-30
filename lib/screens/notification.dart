import 'package:flutter/material.dart';
import 'package:truvender/data/models/notify.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notify> notifications = [];

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: 'Notifications',
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: notifications.isNotEmpty ? notifications.length : 8,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 8),
        itemBuilder: (context, index) {
          if (notifications.isNotEmpty) {
            var notification = notifications[index];
            return NotificationTile(
              notification: notification,
            );
          } else {
            return beforeLoad2();
          }
        },
      ),
    );
  }
}
