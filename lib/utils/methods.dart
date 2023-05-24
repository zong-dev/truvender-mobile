import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:truvender/services/services.dart';
import 'dart:convert';

import 'notifier.dart';

String ucFirst(String text){
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}

String moneyFormat(double value){
  NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
  return numberFormat.format(value);
}

formatDate(String timeString) {
  return DateFormat.yMMMd().add_jm().format(DateTime.parse(timeString));
}

Future<String> showOrHideBalance(String val) async {
    StorageUtil storage = StorageUtil();
    bool hideBal = await storage.getBoolVal("hideBalance");
    if (hideBal == true) {
      return "********";
    }else {
      return val;
    }
    
}

determinUtilRoute(BuildContext context, String path){
  if (path.isNotEmpty) {
    if (path == 'airtime' || path == 'data') {
      context.pushNamed('bill', queryParams: {'type': path, 'view': "mobile-refill"});
    } else if (path == 'cable' || path == 'electric') {
      context.pushNamed('bill', queryParams: {'type': path, 'view': "subscription"});
    } else if (path == 'paypal' || path == 'perfect money') {
      context.pushNamed('other-assets', params: {'name': path});
    }
  }
}

bool usingDarkmode() {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode;
}

Future<dynamic> readDataFromJson(String path) async {
  final String response = await rootBundle.loadString(path);
  final data = await json.decode(response);
  return data;
}


copyToClipBoard(BuildContext context, String text) async {
  await Clipboard.setData( ClipboardData(text: text));
  // ignore: use_build_context_synchronously
  notify(context, "Copied", "success");
}
