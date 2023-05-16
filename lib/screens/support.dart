import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String path) async {
      if (!await launchUrl(
          Uri.parse('$path'))) {
        throw Exception(
            'Could not launch $path');
      }
    }
    return Wrapper(
      title: "Support",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 280,
            width: double.maxFinite,
            child: Image.asset(
              '/assets/images/customer_service.png',
              height: 260,
            ),
          ),
          verticalSpacing(30),
          Text(
            "If you have any issues of need help with your account please contact us via the following channels.",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
          ),
          verticalSpacing(20),
           SupportTile(title: "Email", value: "support@truvender.com", onTap: () => _launchUrl('mail:support@truvender.com')),
        ],
      ),
    );
  }
}

class SupportTile extends StatelessWidget {
  final String title;
  final String value;
  final Function onTap;
  const SupportTile({
    super.key, required this.title, required this.value, required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    getIcon(){
      if(title.toLowerCase() == 'email'){
        return CupertinoIcons.mail_solid;
      }else {
        return CupertinoIcons.phone_circle;
      }
    }


    return InkWell(
      onTap: () {},
      child: Container(
        height: 86,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.textFaded, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1), //(x,y)
                    blurRadius: .8,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  getIcon(),
                  size: 38,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            horizontalSpacing(16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      letterSpacing: 0.2,
                      wordSpacing: 1.5,
                      fontSize: 14.8,
                      fontWeight: FontWeight.w900),
                ),
                verticalSpacing(8),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      letterSpacing: 0.2,
                      wordSpacing: 1.5,
                      fontSize: 14.8,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
