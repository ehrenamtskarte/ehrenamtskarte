import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

typedef OnCardActivationCallback = void Function(String cardData);

Future<StreamSubscription> initUniLinks(
    OnCardActivationCallback onCardActivation) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    var initialUri = await getInitialUri();
    _onUri(onCardActivation, initialUri);
  } on FormatException {
    debugPrint("UniLink is no URI");
  } on PlatformException catch (err) {
    debugPrint("UniLink caused PlatformException: $err");
  }

  var subscription = getUriLinksStream().listen((uri) {
    _onUri(onCardActivation, uri);
  }, onError: (err) {
    debugPrint("UniLink error: $err");
  });

  return subscription;
}

void _onUri(OnCardActivationCallback onCardActivation, Uri uri) {
  if (uri == null || onCardActivation == null) return;
  var cardData = uri.queryParameters["card"];
  if (uri.host == "activate.ehrenamtskarte.app" &&
      cardData.isNotEmpty) {
    onCardActivation(cardData);
  }
}

class UniLinkHandler extends StatefulWidget {
  final Widget child;

  const UniLinkHandler({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UniLinkHandlerState();
}

class _UniLinkHandlerState extends State<UniLinkHandler> {
  StreamSubscription uniLinkHandlingSubscription;

  @override
  void initState() {
    super.initState();
    initUniLinks(_onCardActivated).then((subscription) =>
      uniLinkHandlingSubscription = subscription);
    return; // flutter does not like initState to return futures
  }

  @override
  void dispose() {
    super.dispose();
    uniLinkHandlingSubscription?.cancel();
  }

  void _onCardActivated(String cardData) {
    debugPrint("Card activated with data: $cardData");
    Widget ok = FlatButton(
      child: Text("Na gut"),
      onPressed: () {Navigator.of(context).pop();},
    );
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Karte aktiviert"),
          content: Text(cardData),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}
