/* scaffholding.dart - wraper for components or itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import '../main_header.dart';

import 'callbacks.dart';
import 'resizeline.dart';

class Scaffholding extends Component
{
  Scaffholding(
    {required Key key,
    this.title,
    required this.gconfig,
    required this.direction, //false=vertical, true=horizontal
    required this.showlines,
    required this.subcontainers,
    required this.parentConfigMenu,
    required this.configMenu}) //number of subcontainers
  : super(key: key,gconfig:gconfig,configMenu: configMenu);
  final Function configMenu;
  GeneralConfig gconfig;
  bool showlines;
  final String? title;
  final bool direction;
  final int subcontainers;
  final Function parentConfigMenu;
  @override
  ScaffholdingState createState() => ScaffholdingState();
}

class ScaffholdingState extends State<Scaffholding> with callbacks
{
  final double resizelineWidth=8.0;
  List<Widget> childs = [];
  List<int> width = [];
  BoxConstraints callconstraints=const BoxConstraints();
  // returns the given Widget wraped into a box with rounded corners
  Widget containment(Widget n) 
  {
    return Container(
      alignment: Alignment.center,
      // 5px and 20px should be changed to a value relative to screen size 
      // and relative position
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border:Border.all(width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))),
      child: n,
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Expanded(
        flex: widget.gconfig.flex,
        child: Container(
        alignment: Alignment.center,
        child:LayoutBuilder(builder:(BuildContext context, BoxConstraints constraints){
      callconstraints=constraints;
      //must be before any constructor of Widthline to avoid a racing condition 
      //where the State already finished build but wasn't appended to the DOM
      for(int i=0;i<childs.length;i++){
        if(childs[i].runtimeType==ResizeLine && (childs[i] as ResizeLine).built){
          (childs[i] as ResizeLine).child.setState(() {
            (childs[i] as ResizeLine).length=widget.direction ? constraints.maxHeight: constraints.maxWidth;
            (childs[i] as ResizeLine).enabled=widget.showlines;
          });
        }
        else if(childs[i].runtimeType==Scaffholding && (childs[i] as Scaffholding).built){
          (childs[i] as Scaffholding).setState!(() {
            (childs[i] as Scaffholding).showlines=widget.showlines;
          });
        }
      }

      while( widget.subcontainers*2-1 > childs.length){
        if(childs.isNotEmpty){
          childs.add(ResizeLine(
            key:GlobalKey() ,
            color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
            transparency: 1.0,
            enabled: widget.showlines,
            length: widget.direction ? constraints.maxHeight: constraints.maxWidth,
            width: resizelineWidth,
            direction: widget.direction,
            resizefromline: resizefromline));
        }      
        GeneralConfig<EmptyComponentConfig> tmpconf=GeneralConfig(widget.gconfig.theme, widget.gconfig.flex, EmptyComponentConfig(), EmptyComponent);

        childs.add(EmptyComponent(
          gconfig:tmpconf,
          key: GlobalKey(),
          resizeWidget: resizeWidget,
          replaceChildren: replaceChildren,
          configMenu: widget.configMenu,
        ));
      }
    if(widget.subcontainers*2-1 < childs.length){
      childs.removeRange(max(widget.subcontainers*2-1,0), childs.length);
    }

    //immitation start componentbuild
    widget.built=true;

    if(widget.direction){
      return Row(children: childs);
    }
    else{
      return Column(children: childs);
    }
    })));
  }
}

