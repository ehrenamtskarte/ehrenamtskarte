import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../graphql/graphql_api.graphql.dart';
import '../../home/home_page.dart';
import '../../util/sanitize_contact_details.dart';
import '../map_page.dart';
import 'contact_info_row.dart';

class DetailContent extends StatelessWidget {
  final AcceptingStoreById$Query$PhysicalStore acceptingStore;
  final bool hideShowOnMapButton;

  DetailContent(this.acceptingStore, {this.hideShowOnMapButton = false});

  @override
  Widget build(BuildContext context) {
    final address = acceptingStore.address;
    final contact = acceptingStore.store.contact;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (acceptingStore.store.description != null) ...[
                Text(
                  acceptingStore.store.description,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Divider(
                    thickness: 0.7,
                    height: 48,
                    color: Theme.of(context).primaryColorLight),
              ],
              Column(
                children: <Widget>[
                  if (address != null) ContactInfoRow(
                      Icons.location_on,
                      "${address.street}\n"
                          "${address.postalCode} ${address.location}",
                      "Adresse",
                      onTap: () =>
                          MapsLauncher.launchQuery("${address.street}, "
                              "${address.postalCode} ${address.location}")),
                  if (contact.website != null) ContactInfoRow(
                    Icons.language,
                    prepareWebsiteUrlForDisplay(contact.website),
                    "Website",
                    onTap: () =>
                        launch(prepareWebsiteUrlForLaunch(contact.website)),
                  ),
                  if (contact.telephone != null) ContactInfoRow(
                    Icons.phone,
                    contact.telephone,
                    "Telefon",
                    onTap: () =>
                        launch("tel:${sanitizePhoneNumber(contact.telephone)}"),
                  ),
                  if (contact.email != null) ContactInfoRow(
                    Icons.alternate_email,
                    contact.email,
                    "E-Mail",
                    onTap: () => launch("mailto:${contact.email.trim()}"),
                  ),
                ],
              ),
              if (!hideShowOnMapButton) ...[
                Divider(
                  thickness: 0.7,
                  height: 48,
                  color: Theme.of(context).primaryColorLight,
                ),
                ButtonBar(
                  children: [
                    OutlinedButton(
                      child: Text("Auf Karte zeigen"),
                      onPressed: () => _showOnMap(context),
                    ),
                  ],
                  alignment: MainAxisAlignment.center,
                ),
              ]
            ]));
  }

  void _showOnMap(BuildContext context) {
    HomePage.of(context).goToMap(PhysicalStoreFeatureData(
        acceptingStore.id,
        LatLng(acceptingStore.coordinates.lat, acceptingStore.coordinates.lng),
        acceptingStore.store.category.id));
  }
}
