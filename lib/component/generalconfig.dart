/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import '../main_header.dart';

class GeneralConfig<ContentType>{
    GeneralConfig(this.theme,this.flex,this.cconfig,this.type);
    ThemeData theme; 
    int flex;
    ContentType cconfig;
    Type type;
    Function? configMenu;
  }

class EmptyConfig{}