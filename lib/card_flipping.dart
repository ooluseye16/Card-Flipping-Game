import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'indicator/progressIndicator.dart';
import 'model/cardData.dart';

class CardFlippingGame extends StatefulWidget {
  @override
  _CardFlippingGameState createState() => _CardFlippingGameState();
}

class _CardFlippingGameState extends State<CardFlippingGame> {
  ProgressController controller;

  @override
  void initState() {
    super.initState();
    controller = ProgressController(
      duration: Duration(minutes: 1),
    );
    controller.start();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cardData = Provider.of<CardData>(context, listen: false);
    bool _flipAxis = true;
    cardData.shuffle(cardData.cards);
    Widget _buildFront(int index) {
      return Container(
        key: ValueKey(true),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
        ),
      );
    }

    Widget _buildRear(int index) {
      return Container(
          key: ValueKey(false),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.red,
          ),
          child: Center(
              child: Icon(cardData.shuffled[index].icon,
                  size: 30.0, color: Colors.white)));
    }

    Widget _buildFlipAnimation(int index) {
      return GestureDetector(
        onTap: () {
         
          cardData.flipAndCompare(index);
         
        },
        child: AnimatedSwitcher(
          transitionBuilder: (Widget widget, Animation<double> animation) {
            final rotateAnim = Tween(
              begin: pi,
              end: 0.0,
            ).animate(animation);
            return AnimatedBuilder(
              animation: rotateAnim,
              child: widget,
              builder: (context, widget) {
                final isUnder =
                    (ValueKey(cardData.shuffled[index].selected) != widget.key);
                var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                tilt *= isUnder ? -1.0 : 1.0;
                final value =
                    isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
                return Transform(
                  transform: _flipAxis
                      ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
                      : (Matrix4.rotationY(value)..setEntry(3, 1, tilt)),
                  child: widget,
                  alignment: Alignment.center,
                );
              },
            );
          },
          layoutBuilder: (widget, list) {
            return Stack(
              children: [widget, ...list],
            );
          },
          duration: Duration(milliseconds: 500),
          child: cardData.shuffled[index].selected
              ? _buildFront(index)
              : _buildRear(index),
          switchInCurve: Curves.easeInBack,
          switchOutCurve: Curves.easeInBack.flipped,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
        child: Consumer<CardData>(builder: (context, cardData, _) {
          return cardData.shuffled.isNotEmpty
              ? Column(
                  children: [
                    RestartableCircularProgressIndicator(
                      controller: controller,
                      onTimeout: () {
                        if (cardData.shuffled.isNotEmpty) {
                          return showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("You lost!"),
                                  content: Text(
                                      "You don lose this one o 🥴. Try again padi mi"),
                                  actions: [
                                    InkWell(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      onTap: () => Navigator.popUntil(
                                        context,
                                        ModalRoute.withName("/homePage"),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                    SizedBox(height: 120.0),
                    Expanded(
                      flex: 1,
                      child: GridView.builder(
                          itemCount: cardData.shuffled.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              constraints:
                                  BoxConstraints.tight(Size.square(50.0)),
                              child: _buildFlipAnimation(index),
                            );
                          }),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text("You Won!"),
                  content: Text("Sharp guy!! 🎉. Make we go again?"),
                  actions: [
                    InkWell(
                        child: Text("Ok",style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),),
                        onTap: () {
                          controller.cancelTimers();
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName("/homePage"),
                          );
                        }),
                  ],
                );
        }),
      )),
    );
  }
}
