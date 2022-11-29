/* component_menu.dart - mixin for options common component configs 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
export 'package:smartclock/popups/selectableradio.dart';
mixin Componentmenu{
  BuildContext get context;
    Future<Color> _ColorDialog(BuildContext context,Color color) async{
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: MediaQuery.of(context).orientation == Orientation.portrait
              ? const BorderRadius.vertical(
              top: Radius.circular(500),
              bottom: Radius.circular(100),
            )
            //right radius should be as large as possible
            : const BorderRadius.horizontal(right: Radius.circular(9999),left: Radius.circular(400)),
          ),
          content:SingleChildScrollView(
            child:
            HueRingPicker(
              pickerColor: color,
              onColorChanged: (e){setState(() {color=e;});},
            ),
          ),
        );
      },
    );
    return color;
  }
  void setState(VoidCallback fn);

  Color testcolor=Colors.blue;
  //static final List<String> _cornermap=["round","test"];
  static final List<String> _cornerlist=Bordertype.values.map((dynamic e) => e.toString().split('.').last).toList();
  final List<DropdownMenuItem<String>> _cornerstyle=_cornerlist.map((String e) => DropdownMenuItem<String>(value:e,child: Text(e),)).toList();
  String _corner_style_val=_cornerlist[0];
  Widget componentTile(GeneralConfig generalconfig){
    return ExpansionTile(
    title: const Text("General"),
    children:[
      ExpansionTile(
      title: const Text("Border"),
      children:[
        ListTile(
          leading:SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*4,
            child:Text("Width",style: Theme.of(context).textTheme.titleMedium)
          ),
          trailing: SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text((generalconfig.borderWidth ??globalgconf.borderWidth!).toStringAsFixed(2))),
          title: Slider(value: generalconfig.borderWidth ??globalgconf.borderWidth!, onChanged: (double value){setState((){generalconfig.borderWidth=value;});},
            min:0,
            max:10)
        ),
        ListTile(
          leading:SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*4,
            child:Text("Radius",style: Theme.of(context).textTheme.titleMedium)
          ),
          trailing: Container(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text((generalconfig.borderRadius ??globalgconf.borderRadius!).toStringAsFixed(2))),
          title: Slider(value: generalconfig.borderRadius ??globalgconf.borderRadius!, onChanged: (double value){setState((){generalconfig.borderRadius=value;});},
            min:0,
            max:30)
        ),
        /*ListTile(
          leading:SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*4,
            child:Text("Margin",style: Theme.of(context).textTheme.titleMedium)
          ),
          trailing: SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text(_border_width.toStringAsFixed(2))),
          title: Slider(value: _border_width, onChanged: (double value){setState((){_border_width=value;});},
            min:0,
            max:10)
        ),*/
        ListTile(
          leading:Text("Corner Style",style: Theme.of(context).textTheme.titleMedium),
          title:DropdownButton<String>(
            value: _corner_style_val,
            items: _cornerstyle, 
            onChanged: (e){setState((){_corner_style_val=e ?? _corner_style_val;});})
        ),
        ListTile(
          enabled: true,
          leading:Text("Corner Radius",style: Theme.of(context).textTheme.titleMedium)
        ),
        ListTile(
          enabled: true,
          leading:Text("Border Color",style: Theme.of(context).textTheme.titleMedium),
          //replace at some point with relative size
          title: Icon(Icons.color_lens,color: generalconfig.borderColor ?? const Color.fromARGB(255, 73, 73, 73),size: 45),
          onTap: () {
            _ColorDialog(context,generalconfig.borderColor ?? const Color.fromARGB(255, 73, 73, 73)).then((value) => setState((){generalconfig.borderColor=value;}));
          },
        ),
      ]),
      ExpansionTile(
      title: const Text("Text"),
      children:[
        
      ]),
      ExpansionTile(
      title: const Text("Colors"),
      children:[
        
      ])
      ]
    );
  }
}