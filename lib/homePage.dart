import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/cardData.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Consumer<CardData>(
        builder: (context, cardData, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("CARD FLIP GAME",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.green[800],
                    fontWeight: FontWeight.w500,
                  )),
              RaisedButton(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text("Play",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.green[800],
                      )),
                  onPressed: () async {
                    await Navigator.pushNamed(context, "/card_flipping");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
