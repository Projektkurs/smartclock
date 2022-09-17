/* component.dart - wraper for widgets to apply uniform configs, positioning 
 * and updating
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:smartclock/main_header.dart';

abstract class Component extends StatefulWidget {
  Component({
    required Key key,
    required this.gconfig,
  }): super(key: key);
  //todo: configMenu should be final
  GeneralConfig gconfig;
  bool built=false;
  Function? setState;
  @override
    Map<String, dynamic> toJson() => {
  };
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
      child: SizedBox.expand(child:Container()),
    )
      );
  }

} 
mixin ComponentBuild<Parent extends Component>
{
  //constructor cannot be used as setState will not have been declared at that time
  defaultfirstbuild(){
    widget.built=true;
    widget.setState=setState;
  }
  Parent get widget;
  BuildContext get context;
  void setState(VoidCallback fn);
  Widget componentbuild(Widget child) {
    return Expanded(
      flex: widget.gconfig.flex,
      child:LayoutBuilder(builder:(BuildContext context, BoxConstraints constraints)
      {
        return GestureDetector(
          onDoubleTap:
          (){configmenu([widget.key!],Parent,widget.gconfig,constraints.maxWidth,constraints.maxHeight);},
          child:Container(
          alignment: Alignment.center,
          // 5px and 20px should be changed to a value relative to screen size 
          // and relative position
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border:Border.all(width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))),
          child: SizedBox.expand(child:child)),
      );})
    );
  }
}
