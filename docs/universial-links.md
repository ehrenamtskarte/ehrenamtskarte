# App links (Android) / Universial Links (iOS)

## External docs:
* https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html
* https://developer.android.com/training/app-links/verify-site-associations

## Why not a custom URL schema?
* Can not gracefully handle the case that the app is not yet installed
* Bad apps can register to handle the activation link and tap the card data

## Set up

* On webserver:
  * add webpage to handle cases where the app is not installed (activate.ehrenamtskarte.app)
  * add `.well-known/assetlinks.json` following [this guide](https://developer.android.com/training/app-links/verify-site-associations.html#web-assoc)
    * use [this tool](https://developers.google.com/digital-asset-links/tools/generator) to generate it
    * to get fingerprint (debug only): `keytool -list -v -keystore ~/.android/debug.keystore` (password: `android`)
    * each of our debug and later the release keystore fingerprints have to be added to the `assetlinks.json`
  * add `.well-known/apple-app-site-association` [this guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW4)
    * `appID` has to be found out by one of the iOS people
* In app:
  * Android: add `intent-filter` to `AndroidManifest.xml`
  * Apple: add `Runner.entitlements` file
  * Handle in Flutter using https://pub.dev/packages/uni_links
