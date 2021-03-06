import 'package:flutter/material.dart';

class VerificationResultDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData icon;
  final Color iconColor;

  VerificationResultDialog({
    Key key,
    this.child,
    this.title,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleText = title != null
        ? Text(title, style: theme.textTheme.headline5)
        : null;
    return AlertDialog(
        title: (icon != null)
          ? ListTile(
                leading: Icon(
                    icon,
                    color: iconColor ?? theme.colorScheme.primaryVariant,
                    size: 30
                ),
                title: titleText,
              )
          : titleText,
        content: child,
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"))
        ],
    );
  }
}
