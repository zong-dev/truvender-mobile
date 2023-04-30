import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:truvender/data/models/models.dart';

class FlutterwavePayment extends StatefulWidget {
  
  final Payment data;
  const FlutterwavePayment({ Key? key, required this.data }) : super(key: key);

  @override
  _FlutterwavePaymentState createState() => _FlutterwavePaymentState();
}

class _FlutterwavePaymentState extends State<FlutterwavePayment> {

  static String? publicKey = dotenv.get('FLW_PUBLIC_KEY');
  static String? secretKey = dotenv.get('FLW_SECRET_KEY');

  static String icon = "https://res.cloudinary.com/dtjylm0hd/image/upload/v1678488667/uploads/truvender_grvykn.png";
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}