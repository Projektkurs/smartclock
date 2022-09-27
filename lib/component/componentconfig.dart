/* componentconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import '../main_header.dart';

class ComponentConfig<ContentType>{
    ComponentConfig(this.theme,this.flex,this.config,this.type);
    ThemeData theme; 
    int flex;
    ContentType config;
    Type type;
  }

class ScaffoldingConfig{
  //Map<String,dynamic> toJson() {print("encoding ScaffoldingConfig");return {};}
  Map<String,dynamic> toJson() => {};
  ScaffoldingConfig.fromJson(Map<String,dynamic> json);
  ScaffoldingConfig();
}