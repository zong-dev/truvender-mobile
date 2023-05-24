import 'package:flutter/material.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class VirtualNumberPage extends StatefulWidget {
  const VirtualNumberPage({ Key? key }) : super(key: key);

  @override
  _VirtualNumberPageState createState() => _VirtualNumberPageState();
}

class _VirtualNumberPageState extends State<VirtualNumberPage> {
  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Virtual Number",
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Container(
            height: 260,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            width: double.maxFinite,
            decoration:  BoxDecoration(
              image: const DecorationImage(image: AssetImage(
                'assets/images/maintainance.png',
                
              ), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20)
            ),
            
          ),
          verticalSpacing(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Coming Soon!",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                verticalSpacing(20),
                Text(
                  "Hey there! this part is undergoing finishing touches, please check again some other time.",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
         ],
      ),
    );
  }
}