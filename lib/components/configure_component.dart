/* configure_component.dart - adds new components accordinguto user input
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 *
 * TODO: replace whole component width a menu for usability on small devices
 */

import '../main_header.dart';

class ConfigureComponent extends Component 
{
  
  @override
  ConfigureComponent(
    {required Key key,
    required this.config,
    required this.resizeWidget,
    required this.replaceChildren,
    required this.parentConfigMenu,
    required this.configMenu,
    })
    : super(key: key,config:config,configMenu:configMenu);
  final Function configMenu;
  final ComponentConfig config;
  final Function resizeWidget;
  final Function replaceChildren;
  final Function parentConfigMenu;
  @override
  ConfigureComponentState createState() => ConfigureComponentState();
}
// selectable components it can replace itself with, nothing does nothing
enum Components { nothing, clock, note, scaffholding }

@override
class ConfigureComponentState extends State<ConfigureComponent> with ComponentBuild<ConfigureComponent>
{ 
  double asubchildren = 3;
  bool _horizontal = true;
  
  int width = 1; // the relative widthin the parent
  _increasewidth()
  {
    width += 1;
    widget.resizeWidget(widget.key, width);
  }

  _decreasewidth()
  {
    if (width != 1) {
      width -= 1;
      widget.resizeWidget(widget.key, width);
    }
  }

  Components? _component = Components.nothing;
  _generateWidget()
  {
    Widget newwidget = widget;
    switch (_component) {
      case Components.scaffholding:
        {
          newwidget = Scaffholding(key:GlobalKey(),
            config:ComponentConfig(Theme.of(context),widget.config.flex,ScaffholdingConfig,Scaffholding),
              direction: _horizontal, subcontainers: asubchildren.round(),showlines:false,
              parentConfigMenu: widget.parentConfigMenu,notconfigMenu: (){});
          break;
        }
      case Components.clock:
        {
          ComponentConfig<Clockconfig> newconfig=ComponentConfig<Clockconfig>(widget.config.theme, widget.config.flex,const Clockconfig(), Clock);
          newwidget = Clock(
            key:UniqueKey(),
            config: newconfig,
            configMenu: widget.configMenu,);
          break;
        }
      case Components.note:
        {
          final controller = TextEditingController();
          newwidget = TextField(
            controller: controller,
            maxLines: 100,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Put your note here',
                border: OutlineInputBorder()),
          );
          break;
        }
      default:
        {
          break;
        }
    }
    widget.replaceChildren(widget.key, newwidget);
  }
  @override
  Widget build(BuildContext context) {
      widget.child=this;
      //built=true;
      widget.built=true;
      int tmp=widget.config.flex;
      return component_build(Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text("$tmp"),
        ListTile( // begin Radio to select component
          title: const Text('nothing'),
          leading: Radio<Components>(
            value: Components.nothing,
            groupValue: _component,
            onChanged: (Components? value) {
              setState(() {
                _component = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('clock'),
          leading: Radio<Components>(
            value: Components.clock,
            groupValue: _component,
            onChanged: (Components? value) {
              setState(() {
                _component = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('note'),
          leading: Radio<Components>(
            value: Components.note,
            groupValue: _component,
            onChanged: (Components? value) {
              setState(() {
                _component = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('scaffholding'),
          leading: Radio<Components>(
            value: Components.scaffholding,
            groupValue: _component,
            onChanged: (Components? value) {
              setState(() {
                _component = value;
              });
            },
          ),
        ), // end Radio to select component
        const Text('number subchildren'),
        Slider(
            value: asubchildren,
            max: 6,
            min: 2,
            divisions: 4,
            label: '${asubchildren.round()}',
            onChanged: (double value) {
              setState(() => asubchildren = value);
            }),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('horizontal'),
          Switch(
            onChanged: (bool value) {
              setState(() => _horizontal = value);
            },
            value: _horizontal,
          )
        ]),
        FloatingActionButton( // on click, it replaces itself with the new Widget
            onPressed: _generateWidget, child: const Icon(Icons.add_circle)
        ),
        Flexible( // increases Width
          child: FloatingActionButton(
            onPressed: _increasewidth,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
        Flexible( // decreases Width
          child: FloatingActionButton(
            onPressed: _decreasewidth,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ),
      ],
    ));
  }
}
