/* component_menu.dart - mixin for options common component configs 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/selectableradio.dart';
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
            : const BorderRadius.horizontal(right: Radius.circular(500)),
                      ),
          content:SingleChildScrollView(
          child:
          HueRingPicker(
            pickerColor: color,
            onColorChanged: (e){setState(() {color=e;});},
            //colorPickerWidth: 400,
            pickerAreaBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
                          ),
          ),),
          /*actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],*/
        );
      },
    );
    return color;
  }
  void setState(VoidCallback fn);
  Color testcolor=Colors.blue;
  double _border_width=5;
  double _border_radius=8;
  //static final List<String> _cornermap=["round","test"];
  static final List<String> _cornerlist=Bordertype.values.map((dynamic e) => e.toString().split('.').last).toList();
  final List<DropdownMenuItem<String>> _cornerstyle=_cornerlist.map((String e) => DropdownMenuItem<String>(value:e,child: Text(e),)).toList();
  String _corner_style_val=_cornerlist[0];
  Widget componentTile(){
    return ExpansionTile(
    title: const Text("General"),
    children:[
      ExpansionTile(
      title: const Text("Border"),
      children:[
        ListTile(
          leading:Text("Width",style: Theme.of(context).textTheme.titleMedium),
          trailing: Container(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text("${_border_width.toStringAsFixed(2)}")),
          title: Slider(value: _border_width, onChanged: (double value){setState((){_border_width=value;});},
            min:0,
            max:10)
        ),
        ListTile(
          leading:Text("Padding",style: Theme.of(context).textTheme.titleMedium),
          trailing: Container(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text("${_border_width.toStringAsFixed(2)}")),
          title: Slider(value: _border_width, onChanged: (double value){setState((){_border_width=value;});},
            min:0,
            max:10)
        ),
        ListTile(
          leading:Text("Margin",style: Theme.of(context).textTheme.titleMedium),
          trailing: Container(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text(_border_width.toStringAsFixed(2))),
          title: Slider(value: _border_width, onChanged: (double value){setState((){_border_width=value;});},
            min:0,
            max:10)
        ),
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
          onTap: () {
            _ColorDialog(context,testcolor).then((value) => testcolor=value);
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