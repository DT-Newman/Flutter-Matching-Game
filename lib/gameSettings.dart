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

import 'package:flutter/material.dart';

class GameSettings {
  // The game shows celebratory gifs after matching all of the cards
  // These should be stored as /assets/celebrate[0,1,2 ...].gif
  static int noOfCelebrategifs = 4;

  static var organelle = {
    'nucleus': 'nucleus',
    'er': 'er',
    'golgi': 'golgi',
    'mitochondria': 'mitochondria',
    'lysosome': 'lysosome',
    'centrosome': 'centrosome',
    'microtubule': 'microtubule',
    'actin': 'actin'
  };

  static var cardType = {
    'title': 'title',
    'description': 'description',
    'drawing': 'drawing',
    'if': 'if',
    'em': 'em'
  };

  static List<AssetImage> celebrateImageList = <AssetImage>[
    AssetImage("assets/celebrate0.gif"),
    AssetImage("assets/celebrate1.gif"),
    AssetImage("assets/celebrate2.gif")
  ];
}
