/* vertretungsplan.dart - config menu for Vertretungsplan 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/component_menu.dart';

mixin Vertretungsplanmenu on Componentmenu {
  //start declaration
  Popup get widget;
  bool get emptyVal;
  bool testVal = false;
  Componentenum components = Componentenum.defaultcase;
  dynamic handleOnPressed(int enable);
  void setState(VoidCallback fn);
  //end declaration
  late TextEditingController _roomtextcontroller;
  Widget vertretungsplanmenu() {
    _roomtextcontroller= TextEditingController(text: widget.componentconfig!.cconfig.raum);
    return Row(children:[ Vertretungsplan( 
        key:GlobalKey(),
        //key:const Key("0"),
        gconfig: widget.componentconfig!),
        Expanded(flex: widget.componentconfig!.flex,child:
          ListView(
          children:[Container(
            margin: const EdgeInsets.all(8),
            child: TextField(
            keyboardType: TextInputType.number,
            controller: _roomtextcontroller,
            onSubmitted: (String value){
                widget.componentconfig!.cconfig.raum= value;
            },  
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              
              labelText: 'Raum',),)
        )]))]);
  }

  vertretungsplanmenuapplycallback() {
    _roomtextcontroller= TextEditingController(text: widget.componentconfig!.cconfig.raum);
    if (widget.configsetState != null) {
      (widget.componentconfig!.cconfig as VertretungsplanConfig).neuerplan=true;
      widget.configsetState!(() {});
    }
    handleOnPressed(-1);
  }
}
