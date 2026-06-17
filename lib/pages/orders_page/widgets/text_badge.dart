import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class TextBadge extends StatelessWidget {
  final String text;

  final Color textColor;
  final Color color;

  final Function()? onPressed;
  final bool disabled;
  final int badgeContent;

  const TextBadge({
    super.key,
    required this.text,
    this.color = Colors.grey,
    this.textColor = Colors.black,
    this.onPressed,
    this.disabled = false,
    this.badgeContent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
            backgroundColor:
                MaterialStatePropertyAll(disabled ? Colors.grey : color)),
        child: badges.Badge(
          showBadge: badgeContent > 0,
          position: badges.BadgePosition.custom(top: -6, end: -20),
          badgeContent: Text(badgeContent.toString()),
          child: Text(text,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: textColor, fontSize: 14.0)),
        ),
      ),
    );
  }
}
