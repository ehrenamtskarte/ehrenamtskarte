import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../qr_code_scanner/qr_code_processor.dart';
import '../../qr_code_scanner/qr_code_scanner_page.dart';
import '../verification_card_details.dart';
import '../verification_card_details_model.dart';
import '../verification_error.dart';
import '../verification_hasher.dart';
import '../verification_processor.dart';
import 'verification_info_text.dart';
import 'verification_result.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({
    Key key,
  }) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  VerificationCardDetails verificationCardDetails;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Karte verifizieren"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              VerificationInfoText(),
              Center(
                child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    onPressed: _onScanCodePressed,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Text(
                      "Code einscannen",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .merge(TextStyle(color: Colors.white, fontSize: 20)),
                    )),
              ),
              Consumer<VerificationCardDetailsModel>(
                  builder: (context, verCardDetailsModel, child) {
                return VerificationResult(verCardDetailsModel);
              }),
            ],
          ),
        ));
  }

  void _onScanCodePressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeScannerPage(
            title: "Karte verifizieren",
            onCodeScanned: _handleQrCode,
          ),
        ));
  }

  Future<void> _handleQrCode(String rawQRContent) async {
    // TODO still no beautiful function
    final provider =
    Provider.of<VerificationCardDetailsModel>(context, listen: false);
    void handleError(String message, String errorCode, Exception e) {
      print("Verification failed: ${e.toString()}");
      provider.setVerificationFailure(VerificationError(message,
          errorCode));
    }
    try {
      var cardDetails = processQrCodeContent(rawQRContent);
      final hash = hashVerificationCardDetails(cardDetails);
      provider.setReadyForRemoteVerification(cardDetails, hash);
    } on QrCodeFieldMissingException catch (e) {
      handleError("Die eingescannte Ehrenamtskarte ist nicht gültig, da "
          "erforderliche Daten fehlen.", "${e.missingFieldName}Missing", e);
    } on CardExpiredException catch (e) {
      final dateFormat = DateFormat("dd.MM.yyyy");
      handleError("Die eingescannte Karte ist bereits am "
          "${dateFormat.format(e.expiry)} abgelaufen.", "cardExpired", e);
    } on QrCodeParseException catch (e) {
      handleError("Der Inhalt des eingescannten Codes kann nicht verstanden "
      "werden. Vermutlich handelt es sich um einen QR-Code, der nicht für die "
      "Ehrenamtskarte-App generiert wurde.", "invalidFormat", e);
    } on Exception catch (e) {
      handleError("Ein unbekannter Fehler beim Einlesen des QR-Codes ist "
          "aufgetreten.", "unknownError", e);
    }
  }
}