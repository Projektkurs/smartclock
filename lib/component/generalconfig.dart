/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/component/componentconfig.dart';
import 'package:smartclock/main_header.dart';
class Defaultgeneral{}
class GeneralConfig
{
  GeneralConfig(this.flex,this.cconfig):
    borderWidth=5,
    borderRadius=10,
    padding=5;
 //must be of ContentType Defaultgeneral 
  GeneralConfig.createGeneral():
    cconfig=(Defaultgeneral() as ContentType),
    flex=1;
  
  Type get type{
    print("Gconf-Type get:$cconfig");
    return cconfig.runtimeType;
  }
  int flex;
  late dynamic cconfig;
  double? borderWidth;
  double? borderRadius;
  double? padding;
  Bordertype? bordertype;
  Color? borderColor;


  
  Map<String, dynamic> toJson() => {
    'flex':flex,
    'type':type.toString(),
    'cconfig':cconfig
  };

  GeneralConfig.fromjson(Map<String,dynamic> json,dynamic cconf):
    flex=json['flex'],
    cconfig=cconf
    {
      //print(1);
      //cconfig=cconffromjson(json);
      //print(2);
    }
    //type=stringtoType(json['type']);
  dynamic cconffromjson(Map<String,dynamic> json){
    switch(json['type']){
      case("ScaffholdingConfig"):
        return ScaffoldingConfig.fromJson(json["cconfig"]);
      case("EmptyComponentConfig"):
        return EmptyComponentConfig.fromJson(json["cconfig"]);
      case("ClockConfig"):
        return ClockConfig.fromJson(json["cconfig"]);
      default:
        return EmptyConfig;
    }
  }
}

enum Bordertype{round,sharp,fused}  
//TODO: remove EmptyConfig
class EmptyConfig{
  Map<String, dynamic> toJson() =>{};
}