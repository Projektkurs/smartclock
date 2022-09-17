/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';

class GeneralConfig<ContentType>{
    GeneralConfig(this.flex,this.cconfig,this.type);
    int flex;
    ContentType cconfig;
    Type type;
  Map<String, dynamic> toJson() => {
    'flex':flex,
    'type':serialComponentType(type),
    'cconfig':cconfig
  };
  }
  String serialComponentType(Type type){
    switch(type){
      case(Scaffold):return "Scaffold";
      case(Empty):return "Empty";
      case(Clock):return "Clock";
      case(ExampleComponent):return "ExampleComponent";
      default:return "";
    }
  }
class EmptyConfig{}