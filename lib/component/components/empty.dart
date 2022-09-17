/* empty.dart - initial component used which config can be used to replace itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';

class Empty extends Component 
{
  Empty(
    {required Key key,
    required GeneralConfig gconfig,
    required this.resizeWidget,
    required this.replaceChildren,
    })
    : super(key: key,gconfig:gconfig);
  //final GeneralConfig<EmptyComponentConfig> gconfig;
  final Function resizeWidget;
  final Function replaceChildren;
  @override
  EmptyState createState() => EmptyState();
  Empty.fromJson(Map<String, dynamic> json,this.resizeWidget,this.replaceChildren)
  :
    super(key:GlobalKey(),gconfig:GeneralConfig<EmptyComponentConfig>.fromjson(json['gconfig'], EmptyComponentConfig.fromJson(json['gconfig']['cconfig'])))
  ;
}

class EmptyState extends State<Empty> with ComponentBuild<Empty>
{
  replace(){
    widget.replaceChildren(widget.key, widget.gconfig.cconfig.replacement);
  }
  @override
  void initState() {
    widget.gconfig.cconfig.replace=replace;
    widget.gconfig.cconfig.key=widget.key!;
    defaultfirstbuild();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //widget.config.config.setState=setState;
    if(widget.gconfig.cconfig.apply){
      debugPrint("apply");
    }
    return componentbuild(const SizedBox.expand());
  }
}
