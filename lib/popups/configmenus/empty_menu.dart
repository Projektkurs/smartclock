/* empty_menu.dart - config menu for Empty component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/component/componentconfig.dart';
import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/component_menu.dart';

mixin Emptymenu on Componentmenu {
  //start declaration
  Popup get widget;
  bool get emptyVal;
  bool testVal = false;
  Componentenum components = Componentenum.defaultcase;
  dynamic handleOnPressed(int enable);
  void setState(VoidCallback fn);
  //end declaration
  int scaffoldingchilds=2;
  Widget emptymenu() {
    return Row(children: [
      const Spacer(flex: 1),
      Expanded(
          //start Component Radio
          flex: 10,
          child: ListView(children: [
                    ListTile(
          leading:SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*4,
            child:Text("Width",style: Theme.of(context).textTheme.titleMedium)
          ),
          trailing: SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text((scaffoldingchilds).toStringAsFixed(0))),
            title: Slider(value: scaffoldingchilds.toDouble() , onChanged: (double value){setState((){scaffoldingchilds=value.round().toInt();});},
            min:2,
            max:8)
            ),
            SelectableRadio<Componentenum>(
                value: Componentenum.horizontal,
                groupvalue: components,
                onPressed: () {
                  setState(() {
                    components = Componentenum.horizontal;
                  });
                },
                text: 'Column',
                leading: const Icon(Icons.view_column_rounded)),
            SelectableRadio<Componentenum>(
                value: Componentenum.vertical,
                groupvalue: components,
                onPressed: () {
                  setState(() {
                    components = Componentenum.vertical;
                  });
                },
                text: 'Row',
                leading: const Icon(Icons.table_rows)),
            SelectableRadio<Componentenum>(
              value: Componentenum.clock,
              groupvalue: components,
              onPressed: () {
                setState(() {
                  components = Componentenum.clock;
                });
              },
              text: 'Clock',
              leading: const Icon(Icons.query_builder),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.vertretungsplan,
              groupvalue: components,
              onPressed: () {
                setState(() {
                  components = Componentenum.vertretungsplan;
                });
              },
              text: 'Vertretungsplan',
              leading: const Icon(Icons.query_builder),
            ),
            componentTile(widget.componentconfig!)
          ]) //end Component Radio
          ),
      const Spacer(flex: 1)
    ]);
  }

  emptymenuapplycallback() {
    switch (components) {
      case Componentenum.horizontal:
        widget.componentconfig!.cconfig.replacement =
            Scaffolding(
                key: widget.componentconfig!.cconfig.key,
                direction: true,
                showlines: false,
                subcontainers: 2,
                gconfig: GeneralConfig(
                    widget.componentconfig!.flex, ScaffoldingConfig()));
        widget.componentconfig!.cconfig.apply = true;
        widget.componentconfig!.cconfig.replace!();
        break;
      case Componentenum.vertical:
        widget.componentconfig!.cconfig.replacement =
            Scaffolding(
                key: widget.componentconfig!.cconfig.key,
                direction: false,
                showlines: false,
                subcontainers: scaffoldingchilds,
                gconfig: GeneralConfig(
                    widget.componentconfig!.flex, ScaffoldingConfig()));
        widget.componentconfig!.cconfig.apply = true;
        widget.componentconfig!.cconfig.replace!();
        break;
      case Componentenum.clock:
        widget.componentconfig!.cconfig.replacement = Clock(
            key: (widget.componentconfig!.cconfig as EmptyComponentConfig).key,
            gconfig: GeneralConfig(
                widget.componentconfig!.flex, const ClockConfig()));
        (widget.componentconfig!.cconfig as EmptyComponentConfig).apply = true;
        (widget.componentconfig!.cconfig as EmptyComponentConfig).replace!();
        break;
      case Componentenum.vertretungsplan:
        widget.componentconfig!.cconfig.replacement =
            Vertretungsplan(
                key: (widget.componentconfig!.cconfig as EmptyComponentConfig)
                    .key,
                gconfig: GeneralConfig(
                    widget.componentconfig!.flex, VertretungsplanConfig("007")));
        (widget.componentconfig!.cconfig as EmptyComponentConfig).apply = true;
        (widget.componentconfig!.cconfig as EmptyComponentConfig).replace!();
        break;
      default:
        break;
    }
    components=Componentenum.defaultcase;
    if (widget.configsetState != null) {
      widget.configsetState!(() {});
    }
    handleOnPressed(-1);
  }
}
