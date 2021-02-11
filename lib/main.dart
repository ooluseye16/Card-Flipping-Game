import 'package:boredom_coding/card_flipping.dart';
import 'package:boredom_coding/model/cardData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CardData(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/homePage",
      routes: {
        "/homePage": (context) => HomePage(),
        "/card_flipping": (context) => CardFlippingGame(),
      },
      //home: HomePage()
      );
  }
}

