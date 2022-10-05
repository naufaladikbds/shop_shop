import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class IconWithBadge extends StatelessWidget {
  final int badgeCount;
  final void Function() onPress;
  final Icon icon;

  const IconWithBadge({
    required this.badgeCount,
    required this.onPress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    print('login');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: icon,
          ),
          Positioned(
            top: 8,
            right: 1,
            child: ClipOval(
              child: Container(
                alignment: Alignment.center,
                height: 20,
                width: 20,
                color: Colors.red,
                child: Text(
                  badgeCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
