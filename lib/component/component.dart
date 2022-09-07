/* component.dart - wraper for widgets to apply uniform configs, positioning 
 * and updating
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import '../main_header.dart';

class Component extends StatefulWidget {
    Component({required Key key,required this.config,  required this.configMenu}): super(key: key);
  final Function configMenu;
  ComponentConfig config;  //int flex;
  State child=ComponentState();
  bool built=false;
  changeflex(){}
  @override
  State<Component> createState() => ComponentState();
}

class ComponentState extends State<Component>{
    @override 
  Widget build(BuildContext context) {
    return Expanded(
          flex: widget.config.flex,
          child:  Container(
      alignment: Alignment.center,
      // 5px and 20px should be changed to a value relative to screen size 
      // and relative position
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border:Border.all(width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))),
      child: SizedBox.expand(child:component_build(context)),
    )
      );
  }
  Widget component_build(BuildContext context){
    return Container();
  }
} 
mixin ComponentBuild<Parent extends Component>
{
  Parent get widget;
  BuildContext get context;
  Widget component_build(Widget child) {
    widget.child=(this as State);
    widget.built=true;
    return
    Expanded(
          flex: widget.config.flex,
          child: 
          GestureDetector(
      onDoubleTap:
        (){widget.configMenu(widget.key!,Parent,widget.config);},
      child:Container(
      alignment: Alignment.center,
      // 5px and 20px should be changed to a value relative to screen size 
      // and relative position
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border:Border.all(width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))),
      child: SizedBox.expand(child:child)),
      )
    );
  }
}
