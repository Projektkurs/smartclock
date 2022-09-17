/* misc.dart -  miscellaneous functions and enums
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:smartclock/main_header.dart';

enum Componentenum {horizontal,vertical,clock,defaultcase,empty}

//used by most Components to open the config menu if they are pressed. 
//assigned to configMenuMainParse in main.dart
typedef Configmenu_t= void Function(List<Key> key,Type type,GeneralConfig config,double width,double height);
Configmenu_t configmenu=(List<Key> key,Type type,GeneralConfig config,double width,double height){};

//returns Type of Component
Type stringtoType(String type){
    switch(type){
      case("Scaffolding"):return Scaffolding;
      case("Empty"):return Empty;
      case("Clock"):return Clock;
      case("ExampleComponent"):return ExampleComponent;
      default:return Component;
    }
}