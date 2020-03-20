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


import 'dart:math';
import 'cardManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cardItem.dart';
import 'gameSettings.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} $event');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('${bloc.runtimeType} $error');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CardManager>(
      create: (context) => CardManager(),
      child: MaterialApp(
        title: 'Cell organelle matching game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void showWinDialog(BuildContext context){


    Random rnd = new Random();
    int selectgif = rnd.nextInt( GameSettings.celebrateImageList.length );
    AssetImage selectedCelebrateImage = GameSettings.celebrateImageList[selectgif];


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Congratulations! You matched everything correctly!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            Image(image: selectedCelebrateImage, fit: BoxFit.contain, height: MediaQuery.of(context).size.height - kToolbarHeight - 100,),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double availableHeight = (size.height - kToolbarHeight - 24);
    final double itemmaxHeight = availableHeight / GameSettings.cardType.length;
    final double itemmaxWidth = size.width / 2;
    double spacing = 10;
    double gameWidth = (itemmaxHeight * GameSettings.organelle.length) + ((GameSettings.organelle.length - 2) * 10);
    if(itemmaxWidth > itemmaxHeight){
      spacing = (size.width - (itemmaxHeight * GameSettings.organelle.length)) / (GameSettings.organelle.length - 1);
    }
    return BlocListener<CardManager, CardManagerData>(
      listener: (context, state) {
        setState(() {
        });
    if(state.correctlines > GameSettings.organelle.length - 2) {showWinDialog(context);}
      },
      child: Scaffold(

        body: Builder(
          builder: (context) {
            return
                Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Container(
                    width: gameWidth,
                    child: BlocBuilder<CardManager, CardManagerData>(
                      bloc: BlocProvider.of<CardManager>(context),
                      builder: (context, state) {
                          return GridView.count(
                            shrinkWrap: true,
                            primary: true,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: GameSettings.organelle.values.length,
                            children: state.cardItemList
                                .asMap()
                                .entries
                                .map((e) => CardItemWidget(e.key, e.value))
                                .toList(),
                          );




                      },
                    ),
                  ),
                );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              final bloc = BlocProvider.of<CardManager>(context);
              bloc.add(ResetGame());
            },
            child: Text("Reset"),
            backgroundColor: Colors.blue,
          ),

 // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}



