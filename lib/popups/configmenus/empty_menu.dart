/* empty_menu.dart - config menu for Empty component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/selectableradio.dart';

enum Componentenum {horizontal,vertical,clock,defaultcase}

mixin Emptymenu
{
  //start declaration
  Popup get widget;
  late bool emptyVal;
  bool testVal=false;
  Componentenum components=Componentenum.defaultcase;
  dynamic handleOnPressed(int enable);
  void setState(VoidCallback fn);
  //end declaration

  Widget emptymenu(){
  return Row(children: [
    const Spacer(flex: 2),
    Expanded(//start Component Radio
      flex:1, 
      child: Column(children: [
        SelectableRadio<Componentenum>(
          value: Componentenum.horizontal,
          groupvalue: components,
          onPressed: (){setState(() {components=Componentenum.horizontal;});},
          text: 'Column',
          leading: const Icon(Icons.view_column_rounded)
        ),
        SelectableRadio<Componentenum>(
          value: Componentenum.vertical, 
          groupvalue: components, 
          onPressed: (){setState(() {components=Componentenum.vertical;});}, 
          text: 'Row',
          leading: const Icon(Icons.table_rows)
        ),
        SelectableRadio<Componentenum>(
          value: Componentenum.clock,
          groupvalue: components,
          onPressed: (){setState(() {components=Componentenum.clock;});},
          text: 'Clock',
          leading: const Icon(Icons.query_builder ),
        )
      ])//end Component Radio
    ),
    const Spacer(flex: 2)
    ]);
  }
  emptymenuapplycallback(){
    switch(components){
      case Componentenum.clock:
        (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.replacement=Clock(key: (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.key, gconfig: GeneralConfig<Clockconfig>(widget.componentconfig!.theme, widget.componentconfig!.flex,const Clockconfig(), Clock), configMenu: (){});
        (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.apply=true;
        (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.replace!();
        break;
      default:break;


    }
    handleOnPressed(-1);
  }
}
