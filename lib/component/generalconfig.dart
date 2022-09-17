/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';

class GeneralConfig<ContentType>
{
  GeneralConfig(this.flex,this.cconfig,this.type);
 
  int flex;
  ContentType cconfig;
  Type type;
  
  Map<String, dynamic> toJson() => {
    'flex':flex,
    'type':type.toString(),
    'cconfig':cconfig
  };

  GeneralConfig.fromjson(Map<String,dynamic> json,this.cconfig):
    flex=json['flex'],
    type=stringtoType(json['type']);

}
class EmptyConfig{
  Map<String, dynamic> toJson() =>{};
}