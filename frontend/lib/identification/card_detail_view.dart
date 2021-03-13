import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../graphql/graphql_api.dart';
import 'card_details.dart';
import 'card_svg.dart';
import 'id_card.dart';
import 'verification_qr_code_view.dart';

class CardDetailView extends StatelessWidget {
  final CardDetails cardDetails;
  final VoidCallback onOpenQrScanner;

  CardDetailView({Key key, this.cardDetails, this.onOpenQrScanner})
      : super(key: key);

  get _formattedExpirationDate => cardDetails.expirationDate != null
      ? DateFormat('dd.MM.yyyy').format(cardDetails.expirationDate)
      : "unbegrenzt";

  @override
  Widget build(BuildContext context) {
    final getRegions = GetRegionsQuery();
    return Query(
        options: QueryOptions(
            document: getRegions.document,
            variables: getRegions.getVariablesMap()),
        builder: (result, {fetchMore, refetch}) {
          var isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          var region = result.hasException || result.isLoading
              ? null
              : getRegions
                  .parse(result.data)
                  .regions
                  .firstWhere((element) => element.id == cardDetails.regionId,
                    orElse: () => null);
          return Flex(
            direction: isLandscape ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: isLandscape
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: IdCard(
                        height: isLandscape ? 200 : null,
                        child: CardSvg(cardDetails: cardDetails)),
                  ),
                ],
              ),
              SizedBox(height: 15, width: 15),
              Flexible(
                child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30),
                            child: Text("Mit diesem QR-Code können Sie sich"
                              " bei Akzeptstellen ausweisen:",
                            textAlign: TextAlign.center,)),
                        VerificationQrCodeView(
                          cardDetails: cardDetails,
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: InkWell(
                              child: Text(
                                "Weitere Aktionen",
                                style:
                                TextStyle(color: Theme.of(context).accentColor),
                              ),
                              onTap: onOpenQrScanner),
                        ),

                        /*
                        Text(
                          cardDetails.fullName ?? "",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 5),
                        Text("Gültig bis: $_formattedExpirationDate"),
                        Text(region == null
                            ? ""
                            : "Ausgestellt von: "
                                "${region.prefix} ${region.name}"),
                        SizedBox(
                          height: 24,
                        ),
                        Center(
                            child: MaterialButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => VerificationQrCodeView(
                                      cardDetails: cardDetails,
                                    ));
                          },
                          color: Colors.white,
                          textColor: Colors.black,
                          child: Icon(
                            Icons.qr_code,
                            size: 50,
                          ),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                        )),*/
                      ],
                    )),
              )
            ],
          );
        });
  }
}
