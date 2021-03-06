import 'package:flutter/material.dart';

import '../../configuration/hide_verification_info.dart';

class VerificationInfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("So prüfen Sie die Echtheit einer Ehrenamtskarte"),
      content: SingleChildScrollView(
        child: ListBody(children: [
          Text("Scannen Sie den QR-Code, der auf der „Ausweisen“-Seite Ihres "
              "Gegenübers angezeigt wird. "
              "Daraufhin wird durch eine Server-Anfrage geprüft, ob die "
              "gescannte Ehrenamtskarte gültig ist. "
              "Dazu wird eine Internetverbindung benötigt."),
        ]),
      ),
      actions: [
        TextButton(
          child: Text("Nicht mehr anzeigen"),
          onPressed: () async {
            await setHideVerificationInfo();
            _onDone(context);
          },
        ),
        TextButton(
          child: Text("OK"),
          onPressed: () => _onDone(context),
        )
      ],
    );
  }

  void _onDone(BuildContext context) => Navigator.of(context).pop(true);

  /// Shows a [VerificationInfoDialog].
  /// Returns a future that resolves to true if the user accepted the info,
  /// and to null if the dialog was dismissed.
  static Future<bool> show(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (_) => VerificationInfoDialog(),
    );
  }
}
