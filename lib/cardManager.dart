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

import 'package:bloc/bloc.dart';
import 'package:fluttermatchinggame/cardItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttermatchinggame/gameSettings.dart';

class CardManager extends Bloc<GameEvent, CardManagerData> {
  @override
  Stream<CardManagerData> mapEventToState(GameEvent event) async* {

    //Create a copy of the current state which will be modified and returned at the end of this function.
    CardManagerData newState = CardManagerData.raw(
        state.selectedList,
        state.cardItemList
            .map((e) =>
            CardItem(e.id, e.cardType, e.organelle, e.asset,
                e.cardState, e.currentPosition))
            .toList(),
        state.correctlines, state.selectedTypeList);

    
    if (event is SelectCard) {

      int position = event.position;
      String selectedCardType = newState.cardItemList.elementAt(position).cardType;

      
      switch (newState.cardItemList
          .elementAt(position)
          .cardState) {
        case CardState.none:
          {
            // Check and make sure a card of the same type isn't already selected
            bool cardTypeAlreadySelected = newState.selectedTypeList.contains(selectedCardType);

            
            //only enter loop if a card of that type hasn't already been selected
            if (!cardTypeAlreadySelected) {

              //Update state information to confirm current card is selected
              newState.cardItemList
                  .elementAt(position)
                  .cardState =
                  CardState.selected;
              newState.selectedList.add(position);
              newState.selectedTypeList.add(selectedCardType);

              //If the user has selected one of every card type check if the guesses are correct
              if (newState.selectedList.length == GameSettings.cardType.length) {
                bool correct = true;
                int n = 1;
                String testorganelle =
                    newState.cardItemList
                        .elementAt(newState.selectedList[0])
                        .organelle;
                while (n < GameSettings.cardType.length) {
                  if (newState.cardItemList
                      .elementAt(newState.selectedList[n])
                      .organelle !=
                      testorganelle) {
                    correct = false;
                    break;
                  }
                  n++;
                }


                if (correct) {
                  List<CardItem> newCorrectCardItemList = new List<CardItem>();
                  newState.selectedList.forEach((element) {
                    newState.cardItemList
                        .elementAt(element)
                        .cardState =
                        CardState.correct;
                    newCorrectCardItemList.add(newState.cardItemList.elementAt(
                        element)); //add the ID of the current card to the list
                  });

                  //for current newly correct cards find them by id and move them to their correct position
                  newCorrectCardItemList.forEach((cardA) {
                    CardItem cardB = newState.cardItemList
                        .elementAt(
                        cardA.id); //the card at cardA actual position
                    int cardBnewPosition = newState.cardItemList.indexOf(cardA);
                    newState.cardItemList[cardA.id] = cardA;
                    newState.cardItemList[cardBnewPosition] = cardB;
                  });

                  //Add one to the number of correct lines
                  newState.correctlines = state.correctlines + 1;

                } else {
                  //reset the state of the incorrectly selected cards
                  newState.selectedList.forEach((element) {
                    newState.cardItemList
                        .elementAt(element)
                        .cardState =
                        CardState.none;
                  });
                }

                //Reset the lists which track selected cards
                newState.selectedList = new List<int>();
                newState.selectedTypeList = new List<String>();
              }
            }
          }
          break;

        case CardState.selected:
          //The card is currently selected so unselect the pressed card
          newState.cardItemList
              .elementAt(position)
              .cardState = CardState.none;
          newState.selectedList.removeWhere((element) => element == position);
          newState.selectedTypeList.remove(selectedCardType);
          break;
        case CardState.correct:
        //Do nothing is the element is already in the correct position
          break;
      }

      yield newState;
    }

    if (event is ResetGame) {
      newState.selectedList = new List<int>();
      newState.cardItemList = generateCardList();
      newState.correctlines = 0;
      newState.selectedTypeList = new List<String>();
      yield newState;
    }
  }

  @override
  CardManagerData get initialState => CardManagerData.generate();
}

class CardManagerData extends Equatable {
  List<int> selectedList;
  List<CardItem> cardItemList;
  List<String> selectedTypeList;
  int correctlines;

  CardManagerData.generate() {
    selectedList = new List<int>();
    cardItemList = generateCardList();
    correctlines = 0;
    selectedTypeList = new List<String>();
  }

  CardManagerData.raw(this.selectedList, this.cardItemList, this.correctlines, this.selectedTypeList);

  @override
  List<Object> get props => [selectedList, cardItemList, correctlines, selectedTypeList];
}

abstract class GameEvent extends Equatable {
  const GameEvent();
  @override
  List<Object> get props => [];

}

class SelectCard extends GameEvent {
  final int position;
  const SelectCard({@required this.position});
}

class ResetGame extends GameEvent{

}
