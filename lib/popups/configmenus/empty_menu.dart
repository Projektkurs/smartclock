/* empty_menu.dart - config menu for Empty component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/component/componentconfig.dart';
import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/component_menu.dart';

mixin Emptymenu on Componentmenu
{
  //start declaration
  Popup get widget;
  bool get emptyVal;
  bool testVal=false;
  Componentenum components=Componentenum.defaultcase;
  dynamic handleOnPressed(int enable);
  void setState(VoidCallback fn);
  //end declaration

  Widget emptymenu(){
  return Row(children: [
    const Spacer(flex: 1),
    Expanded(//start Component Radio
      flex:10, 
      child: ListView(children: [
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
        ),
        componentTile(widget.componentconfig!)
      ])//end Component Radio
    ),
    const Spacer(flex: 1)
    ]);
  }
  emptymenuapplycallback(){
    switch(components){
      case Componentenum.horizontal:
        (widget.componentconfig! as GeneralConfig).cconfig.replacement=Scaffolding(
          key: (widget.componentconfig! as GeneralConfig).cconfig.key,
          direction: true,
          showlines: false,
          subcontainers: 2,
          gconfig: GeneralConfig(widget.componentconfig!.flex,
          ScaffoldingConfig()));
        (widget.componentconfig! as GeneralConfig).cconfig.apply=true;
        (widget.componentconfig! as GeneralConfig).cconfig.replace!();
        break;
      case Componentenum.vertical:
        (widget.componentconfig! as GeneralConfig).cconfig.replacement=Scaffolding(
          key: (widget.componentconfig! as GeneralConfig).cconfig.key,
          direction: false,
          showlines: false,
          subcontainers: 2,
          gconfig: GeneralConfig(widget.componentconfig!.flex,
          ScaffoldingConfig()));
        (widget.componentconfig! as GeneralConfig).cconfig.apply=true;
        (widget.componentconfig! as GeneralConfig).cconfig.replace!();
        break;
      case Componentenum.clock:

        (widget.componentconfig! as GeneralConfig).cconfig.replacement=Clock(
          key: (widget.componentconfig!.cconfig as EmptyComponentConfig).key,
          gconfig: GeneralConfig(widget.componentconfig!.flex,
          const ClockConfig()));
        (widget.componentconfig!.cconfig as EmptyComponentConfig).apply=true;
        (widget.componentconfig!.cconfig as EmptyComponentConfig).replace!();
        break;
      default:break;

    }
    if(widget.configsetState != null){
      widget.configsetState!((){});
    }
    handleOnPressed(-1);
  }
}
