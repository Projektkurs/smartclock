/* empty_component - initial component used which config can be used to replace itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';

class EmptyComponent extends Component 
{
  
  @override
  EmptyComponent(
    {required Key key,
    required this.gconfig,
    required this.resizeWidget,
    required this.replaceChildren,
    required this.parentConfigMenu,
    required this.configMenu,
    })
    : super(key: key,gconfig:gconfig,configMenu:configMenu);
  final Function configMenu;

  final ComponentConfig<EmptyComponentConfig> gconfig;
  final Function resizeWidget;
  final Function replaceChildren;
  final Function parentConfigMenu;
  @override
  EmptyComponentState createState() => EmptyComponentState();
}

class EmptyComponentState extends State<EmptyComponent> with ComponentBuild<EmptyComponent>
{
  replace(){
    (widget.gconfig.cconfig.replacement as Component).configMenu=widget.configMenu;
    widget.replaceChildren(widget.key, widget.gconfig.cconfig.replacement);
  }
  @override
  Widget build(BuildContext context) {
    widget.gconfig.cconfig.replace=replace;
    //widget.config.config.setState=setState;
    if(widget.gconfig.cconfig.apply){
      print("apply");
    }
    return component_build(const SizedBox.expand());
  }
}
