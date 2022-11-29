/* misc.dart -  miscellaneous functions and enums
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:smartclock/component/componentconfig.dart';
import 'package:smartclock/component/components/vertretungsplan.dart';
import 'package:smartclock/main_header.dart';

enum Componentenum {
  horizontal,
  vertical,
  clock,
  defaultcase,
  empty,
  vertretungsplan
}

//used by most Components to open the config menu if they are pressed.
//assigned to configMenuMainParse in main.dart
typedef Configmenut = void Function(List<Key> key, GeneralConfig config,
    double width, double height, void Function(VoidCallback fn) configsetState);
Configmenut configmenu = (List<Key> key, GeneralConfig config, double width,
    double height, void Function(VoidCallback fn) configsetState) {};

//returns Type of Component
Type stringtoType(String type) {
  switch (type) {
    case ("Scaffolding"):
      return Scaffolding;
    case ("ScaffoldingConfig"):
      return ScaffoldingConfig;
    case ("Empty"):
      return Empty;
    case ("EmptyComponentConfig"):
      return EmptyComponentConfig;
    case ("Clock"):
      return Clock;
    case ("ClockConfig"):
      return ClockConfig;
    case ("ExampleComponent"):
      return ExampleComponent;
    case ("Vertretungsplan"):
      return Vertretungsplan;
    case ("VertretungsplanConfig"):
      return VertretungsplanConfig;
    default:
      return Component;
  }
}
