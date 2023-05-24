import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truvender/widgets/widgets.dart';


export 'methods.dart';
export 'spacing.dart';
export 'notifier.dart';
export 'network.dart';
export 'widget.dart';
export 'socket.dart';
export 'custom_validators.dart';

List actions = [
  {
    'name': "Paypal funds",
    "image": CustomIcons.paypal,
    "route": 'paypal',
    "ofWallet" : false,
  },
  {
    'name': "Buy Airtime",
    'image': CupertinoIcons.phone_fill,
    "route": "airtime",
    "ofWallet" : true,
  },
  {
    'name': "Perfect money",
    "image": 'assets/images/perfectMoney.png',
    "route": 'perfect money',
    "ofWallet" : false,
  },
  {
    'name': "Buy Data",
    "image": CupertinoIcons.rectangle_arrow_up_right_arrow_down_left,
    "route": 'data',
    "ofWallet" : true,
  },
  {
    "name": "Cable Subscription",
    "image": Icons.router_rounded,
    "route": 'cable',
    "ofWallet" : true,
  },
  {
    "name": "Electricity",
    "image": Icons.electric_bolt,
    "route": 'electric',
    "ofWallet" : true,
  }
];

List tradables = [
  {
    "name": 'Gift card',
    "description": "Buy and sell giftcards like iTunes, Amazon, and more",
    "icon": CupertinoIcons.gift_alt_fill,
    "route": "giftcard",
  },
  {
    "name": "Crypto",
    "description": "Buy and sell crypto",
    "icon": CupertinoIcons.bitcoin_circle_fill,
    "route": "crypto",
  },
  {
    "name": "Temporary number",
    "description": "Buy real virtual number",
    "icon": CupertinoIcons.phone_down_fill,
    "route": "virtualNumber",
  },
  {
    "name": "Spending cards",
    "description": "Trade cards like Walmart Money, GreenDot funds & more",
    "icon": CupertinoIcons.creditcard_fill,
    "route": "spending-card",
  },
  {
    "name": "Others assets",
    "description": "Other assets to trade with truvender",
    "icon": Icons.card_travel,
    "route": "other-assets",
  },
];


var currentNavPage = 0;


List<Map> refillServiceProviders = [
  {"name": 'mtn', "billCode": 'BIL108', "image": "assets/vectors/mtn.svg"},
  {"name": 'glo', "billCode": 'BIL109', "image": "assets/vectors/glo.svg"},
  {"name": 'airtel', "billCode": 'BIL110', "image": "assets/vectors/airtel.svg"},
  {"name": '9mobile', "billCode": 'BIL111', "image": "assets/vectors/9mobile.svg"},
];

List<Map> billsServiceProviders = [
  {"name": 'dstv', "billCode": 'BIL104', "image": "assets/images/dstv.png"},
  {"name": 'gotv', "billCode": 'BIL105', "image": "assets/images/gotv.png"},
  {"name": 'startimes', "billCode": 'BIL106', "image": "assets/images/startimes.png"},
];
