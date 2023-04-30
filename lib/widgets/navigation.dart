import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/utils/utils.dart';

import '../theme.dart';

class BottomNavigator extends StatefulWidget {
  final ValueChanged<int> onItemSelected;

  const BottomNavigator({Key? key, required this.onItemSelected})
      : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {

  int selecteIndex = currentNavPage;
 
  void handleItemSelect(int index) {
    widget.onItemSelected(index);
    setState(() {
      selecteIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                  label: "Home",
                  icon: Icons.grid_view_rounded,
                  index: 0,
                  onTap: handleItemSelect,
                  currentIndex: selecteIndex),
              _NavigationBarItem(
                  label: "Wallets",
                  icon: CupertinoIcons.rectangle_fill_on_rectangle_fill,
                  index: 1,
                  onTap: handleItemSelect,
                  currentIndex: selecteIndex),
              _NavigationBarItem(
                  label: "Trades",
                  icon: Icons.history,
                  index: 2,
                  onTap: handleItemSelect,
                  currentIndex: selecteIndex),
              _NavigationBarItem(
                  label: "My Account",
                  icon: Icons.account_circle_outlined,
                  index: 3,
                  onTap: handleItemSelect,
                  currentIndex: selecteIndex),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem(
      {Key? key,
      required this.label,
      required this.icon,
      required this.index,
      required this.currentIndex,
      required this.onTap})
      : super(key: key);

  final ValueChanged<int> onTap;
  final String label;
  final int index;
  final IconData icon;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        try {
          onTap(index);
        } catch (e) {
          // print(e);
        }
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: currentIndex == index? Theme.of(context).colorScheme.primary : null,
            ),
            horizontalSpacing(8),
            Text(
              label,
              style: currentIndex == index                  ? TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}
