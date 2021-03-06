import 'package:flutter/material.dart';

import 'app.dart';
import 'configuration/configuration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Configuration(
      mapStyleUrl: "https://tiles.ehrenamtskarte.app/style.json",
      graphqlUrl: "https://api.ehrenamtskarte.app",
      showVerification: false,
      child: App()));
}
