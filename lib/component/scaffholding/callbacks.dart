/* callbacks.dart - callbacks assigned by ScaffholdingState 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'resizeline.dart';

mixin callbacks
{
  List<Widget> get childs;
  Scaffolding get widget;
  List<int> get width;
  BoxConstraints get callconstraints;
  double get resizelineWidth;
  void setState(VoidCallback fn);

  int _caller(key)
  {
    for (int i=0;i<childs.length;i++){
      if(childs[i].key == key) return i;
    }
    //not called by child of scaffholding
    Exception("Key not found in callback of scaffholding");
    //return 0 to not crash the program 
    return 0;
  }
  //Key used so children can replace themselves without needing to know their relative position.
  resizeWidget(Key key, int width) 
  {
    setState(() {
      this.width[_caller(key)] = width;
    });
  }

  //todo check which key is used for new widget.
  //replaces the Widget of given key.
  replaceChildren(Key key, Widget newwidget) 
  {
    //caller might not have recent information on showlines of main
    //scaffholding is guaranteed to have
    if(newwidget.runtimeType==Scaffolding){
      (newwidget as Scaffolding).showlines=widget.showlines;
    }
    setState(() {
      childs[_caller(key)] = newwidget;
    });
  }

  //used soley by ResizeLine
  resizefromline(Key key, double length){
    //search which widget called function
    int caller=_caller(key); 
    if((childs[caller] as ResizeLine).built) {
      //update callcontext
      setState(() { });
      //pixels in main direction excluding ResizeLine which is not flex
      double width =
        widget.direction? callconstraints.maxWidth : callconstraints.maxHeight
        -(childs.length-1)*resizelineWidth;
      double totalflex=0;
      for(int n=0;n<widget.subcontainers;n++){
        totalflex+=(childs[n*2] as Component).gconfig.flex;
      }
      int flexdif=(totalflex*(length/width)).floor();
      setState(() {
        (childs[caller-1] as Component).setState!(() {
          (childs[caller-1] as Component).gconfig.flex+=flexdif;
        });
        (childs[caller+1] as Component).setState!(() {
          (childs[caller+1] as Component).gconfig.flex-=flexdif;
        });
      });
    }//todo: do future call with delay so it will be built eventually
  }
}