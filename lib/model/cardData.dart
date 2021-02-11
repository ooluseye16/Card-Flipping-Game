import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cardmodel.dart';

class CardData extends ChangeNotifier {
  double progressValue = 0.0;

  bool loading;

  // CardData() {
  //   init();
  // }

  init() {
    shuffle(cards);
    updateProgress();
  }

  List<CardModel> cards = [
    CardModel(
      id: 1,
      icon: Icons.settings,
    ),
    CardModel(
      id: 2,
      icon: Icons.ac_unit,
    ),
    CardModel(
      id: 3,
      icon: Icons.account_balance,
    ),
    CardModel(id: 4, icon: Icons.gamepad),
    CardModel(id: 5, icon: Icons.receipt),
    CardModel(id: 6, icon: Icons.plumbing),
    CardModel(
      id: 7,
      icon: Icons.explore,
    ),
    CardModel(
      id: 8,
      icon: Icons.backpack,
    ),
    CardModel(
      id: 9,
      icon: Icons.settings,
    ),
    CardModel(
      id: 10,
      icon: Icons.ac_unit,
    ),
    CardModel(
      id: 11,
      icon: Icons.account_balance,
    ),
    CardModel(id: 12, icon: Icons.gamepad),
    CardModel(id: 13, icon: Icons.receipt),
    CardModel(id: 14, icon: Icons.plumbing),
    CardModel(
      id: 15,
      icon: Icons.explore,
    ),
    CardModel(
      id: 16,
      icon: Icons.backpack,
    ),
  ];

  List<CardModel> shuffled = [];
  void shuffle(List<CardModel> cards) {
    cards.forEach((val) {
      if ((shuffled.singleWhere((it) => it.id == val.id, orElse: () => null)) !=
          null) {
          val.selected = true;  
      } else {
        shuffled.add(val);
        val.selected = true;
      }
    });
    shuffled.shuffle();
  }

  List<CardModel> compareThis = [];
  void flipAndCompare(int index) {
    shuffled[index].selected = !shuffled[index].selected;
    notifyListeners();
    if (!shuffled[index].selected && compareThis.length < 2) {
      compareThis.add(shuffled[index]);
      notifyListeners();
      Future.delayed(Duration(milliseconds: 600), () {
        if (compareThis.length == 2) {
          if (compareThis[0].icon == compareThis[1].icon) {
            shuffled
                .removeWhere((element) => element.icon == compareThis[0].icon);
            compareThis.clear();
            notifyListeners();
          } else {
            for (var card in compareThis) {
              card.selected = true;
            }
            compareThis.clear();
          }
        }
        notifyListeners();
      });
    } else if (shuffled[index].selected) {
      compareThis.remove(shuffled[index]);
      notifyListeners();
    }
  }

  void updateProgress() {
    const oneSec = const Duration(milliseconds: 500);
    new Timer.periodic(oneSec, (Timer t) {
      progressValue += 0.05;
      notifyListeners();
      if (progressValue.toStringAsFixed(1) == '1.0') {
        loading = false;
        t.cancel();
        //progressValue==0.0;
        notifyListeners();
        return;
      }
    });
  }
}
