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
    required this.config,
    required this.resizeWidget,
    required this.replaceChildren,
    required this.parentConfigMenu,
    required this.configMenu,
    })
    : super(key: key,config:config,configMenu:configMenu);
  final Function configMenu;

  final ComponentConfig<EmptyComponentConfig> config;
  final Function resizeWidget;
  final Function replaceChildren;
  final Function parentConfigMenu;
  @override
  EmptyComponentState createState() => EmptyComponentState();
}

class EmptyComponentState extends State<EmptyComponent> with ComponentBuild<EmptyComponent>
{
  replace(){
    (widget.config.config.replacement as Component).configMenu=widget.configMenu;
    widget.replaceChildren(widget.key, widget.config.config.replacement);
  }
  @override
  Widget build(BuildContext context) {
    widget.config.config.replace=replace;
    //widget.config.config.setState=setState;
    if(widget.config.config.apply){
      print("apply");
    }
    return component_build(const SizedBox.expand());
  }
}
