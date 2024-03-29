/* example.dart - example to build a barebones component
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';

class ExampleComponent extends Component 
{
  
  @override
  ExampleComponent(
    {required Key key,
    required GeneralConfig gconfig,
    required this.resizeWidget,
    required configMenu,
    })
    : super(key: key,gconfig:gconfig);

  final Function resizeWidget;
  @override
  ExampleComponentState createState() => ExampleComponentState();
}

class ExampleComponentState extends State<ExampleComponent> with ComponentBuild<ExampleComponent>
{
  @override
  void initState() {
    defaultfirstbuild();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return componentbuild(Container(
      color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      child:const SizedBox.expand())
    );
  }
}
