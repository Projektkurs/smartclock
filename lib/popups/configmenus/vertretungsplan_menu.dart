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

  Widget vertretungsplanmenu() {
    return const SizedBox.expand();

    /*Row(
          children: [
              Vertretungsplan( 
        key:const Key("0"),
        gconfig: widget.componentconfig!),
        Expanded(flex: widget.componentconfig!.flex,child:
        ListView(
          children:
          
                    [Expanded(
            flex:widget.componentconfig!.flex,
            child:
              SizedBox.expand(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('darkmode'),
          Switch(
            onChanged: (bool value) {
              setState(()  {_darkmode = value;
              if(_darkmode && widget.componentconfig!.cconfig.runtimeType==VertretungsplanConfig){
                widget.componentconfig!.cconfig=const VertretungsplanConfig.dark();
              }else{
                widget.componentconfig!.cconfig=const VertretungsplanConfig();
              }
              });
            },
            value: _darkmode,
          )
        ]))),
        //componentTile(widget.componentconfig!)
        ]))]);*/
  }

  vertretungsplanmenuapplycallback() {
    if (widget.configsetState != null) {
      widget.configsetState!(() {});
    }
    handleOnPressed(-1);
  }
}
