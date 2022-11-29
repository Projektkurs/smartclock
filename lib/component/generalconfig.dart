/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/component/componentconfig.dart';
import 'package:smartclock/main_header.dart';
class Defaultgeneral{}
class GeneralConfig
{
  GeneralConfig(this.flex,this.cconfig);

  //must be of ContentType Defaultgeneral 
  GeneralConfig.createGeneral():
    cconfig=Defaultgeneral(),
    flex=1,
    borderWidth=5,
    borderRadius=10,
    padding=5;

  
  Type get type{
    debugPrint("Gconf-Type get:$cconfig");
    return cconfig.runtimeType;
  }
  int flex;
  late dynamic cconfig;
  double? borderWidth;
  double? borderRadius;
  double? padding;
  Bordertype? bordertype;
  Color? borderColor;


  
  Map<String, dynamic> toJson(){
    Map<String,dynamic> map= {
    'flex':flex,
    'type':type.toString(),
    'cconfig':cconfig,
    //border:
    'borderWidth':borderWidth,
    'borderRadius':borderRadius,
    };
    if(borderColor!=null){
      map['bordercolor'] = borderColor!.value;
    }
    if(borderWidth!=null){
      map['borderWidth'] = borderWidth;
    }
    if(borderRadius!=null){
      map['borderRadius'] = borderRadius;
    }
    return map;
  }

  GeneralConfig.fromjson(Map<String,dynamic> json,dynamic cconf):
    flex=json['flex'],
    cconfig=cconf,
    //border
    borderWidth=json["borderWidth"],
    borderRadius=json["borderRadius"]; 
    //type=stringtoType(json['type']);
}

enum Bordertype{round,sharp,fused}  