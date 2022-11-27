/* clock_menu.dart - config menu for Clock component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/component_menu.dart';

mixin Clockmenu on Componentmenu
{
  //start declaration
  Popup get widget;
  bool get emptyVal;
  bool testVal=false;
  Componentenum components=Componentenum.defaultcase;
  dynamic handleOnPressed(int enable);
  void setState(VoidCallback fn);
  //end declaration
  bool _darkmode=false;

  Widget clockmenu(){
  return Row(children:[ Clock( 
        key:GlobalKey(),
        //key:const Key("0"),
        gconfig: widget.componentconfig!),
        Expanded(flex: widget.componentconfig!.flex,child:
          ListView(
          children:[
            ListTile(
            leading: Text("darkmode",style: Theme.of(context).textTheme.titleMedium),
            title:Switch(
            onChanged: (bool value) {
              setState(()  {_darkmode = value;
              if(_darkmode && widget.componentconfig!.cconfig.runtimeType==ClockConfig){
                widget.componentconfig!.cconfig=const ClockConfig.dark();
              }else{
                widget.componentconfig!.cconfig=const ClockConfig();
              }
              });
            },
            value: _darkmode,
          )
            ),
            componentTile(widget.componentconfig!)]))]);
         /*     SizedBox.expand(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('darkmode'),
          Switch(
            onChanged: (bool value) {
              setState(()  {_darkmode = value;
              if(_darkmode && widget.componentconfig!.cconfig.runtimeType==ClockConfig){
                widget.componentconfig!.cconfig=const ClockConfig.dark();
              }else{
                widget.componentconfig!.cconfig=const ClockConfig();
              }
              });
            },
            value: _darkmode,
          )*/
        //]))),
        //componentTile(widget.componentconfig!)
  }
  clockmenuapplycallback(){
    if(widget.configsetState != null){
      widget.configsetState!((){});
    }
    handleOnPressed(-1);
  }
}
