/* component.dart - wraper for widgets to apply uniform configs, positioning 
 * and updating
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import '../main_header.dart';

class Component extends StatefulWidget {
  Component({
    required Key key,
    required this.gconfig,
    required this.configMenu
  }): super(key: key);
  //todo: configMenu should be final
  Function configMenu;
  GeneralConfig gconfig;
  bool built=false;
  Function? setState;
  @override
  State<Component> createState() => ComponentState();
}

class ComponentState extends State<Component>{
    @override 
  Widget build(BuildContext context) {
    return Expanded(
          flex: widget.gconfig.flex,
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
  //constructor cannot be used as setState will not have been declared at that time
  bool firstbuild=true;
  defaultfirstbuild(){
    widget.built=true;
    widget.setState=setState;
    firstbuild=false;
  }
  Parent get widget;
  BuildContext get context;
  void setState(VoidCallback fn);
  Widget component_build(Widget child) {
    return Expanded(
          flex: widget.gconfig.flex,
          child: 
          GestureDetector(
      onDoubleTap:
        (){widget.configMenu([widget.key!],Parent,widget.gconfig);},
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
