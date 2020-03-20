/*

Copyright (c) 2020 Daniel Newman

This file is part of "Daniel's flutter matching game".

"Daniel's flutter matching game" is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

"Daniel's matching game" is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with "Daniel's matching game".  If not, see <https://www.gnu.org/licenses/>.*/

import 'cardManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'gameSettings.dart';



enum CardState { none, selected, correct }

class CardItem extends Equatable {

  String cardType;
  String organelle;
  String asset;
  int id;
  CardState cardState;
  int currentPosition;


  CardItem(this.id, this.cardType, this.organelle, this.asset, this.cardState, this.currentPosition);

  @override
  List<Object> get props => [id, cardType, organelle, asset, cardType, cardState, currentPosition];

}

class CardItemWidget extends StatelessWidget {
  CardItemWidget(this.position, this.cardItem);
  int position;
  CardItem cardItem;


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CardManager>(context);
    bool isTypeSelected = bloc.state.selectedTypeList.contains(cardItem.cardType);
    double opacity = 1;
    if(isTypeSelected && (cardItem.cardState != CardState.selected) ){ opacity = 0.3;}
    return Opacity(
      opacity: opacity,
      child: Card(
          color: Colors.white70,
          shape: cardItem.cardState == CardState.selected
              ? new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.blue, width: 4.0),
                  borderRadius: BorderRadius.circular(4.0))
              : cardItem.cardState == CardState.correct
              ?  new RoundedRectangleBorder(
              side: new BorderSide(color: Colors.green, width: 4.0),
              borderRadius: BorderRadius.circular(4.0))
              : new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 4.0),
                  borderRadius: BorderRadius.circular(4.0)),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              bloc.add(SelectCard(position: position));
            },
            onLongPress: () {showImageDialog(context, cardItem.asset);},
            child:Image(image: AssetImage(cardItem.asset)),
          )),
    );
  }


}

List<CardItem> generateCardList() {
  var returnList = new List<CardItem>();
  int correctposition = 0;

  GameSettings.cardType.forEach((cardkey, cardType) {
    GameSettings.organelle.forEach((organellekey, organelle) {
      var asset = 'assets/' + organelle + cardType + '.png';
      returnList.add(CardItem(correctposition, cardType, organelle, asset, CardState.none, correctposition));
      correctposition++;
    });
  });

  // Shuffle the list

  int organellenumber = GameSettings.organelle.length;
  int cardtypes = GameSettings.cardType.length;
  int totalCards = organellenumber * cardtypes;

  var newList = new List<CardItem>();

  for (int n = organellenumber; n < totalCards; n = n + organellenumber) {
    int offset = n + organellenumber;
    var subList = new List<CardItem>();
    subList = returnList.sublist(n, offset);
    subList.shuffle();
    returnList.replaceRange(n, offset, subList);
  }

  return returnList;
}

showImageDialog(BuildContext context,String imageAsset){


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Image(image: AssetImage(imageAsset)),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}
