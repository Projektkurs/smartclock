/* selectableradio.dart - alternative to normal radio 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 * 
 * this is a custom selectable radio which functions identicaly like the original,
 * with some features not implemented. It just differs in appearance
 */

import 'package:smartclock/main_header.dart';

class SelectableRadio<T> extends StatefulWidget {
  const SelectableRadio({
    super.key,
    required this.value,
    required this.groupvalue,
    required this.onPressed,
    required this.text,
    this.leading
  });

  final T value;
  final T groupvalue;
  final VoidCallback onPressed;
  final String text;
  final Widget? leading;
  @override
  State<SelectableRadio> createState() => _SelectableRadioState();
}

class _SelectableRadioState extends State<SelectableRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,  
      child:ListTile(
        leading: widget.leading,
        title: Text(widget.text,
          style:TextStyle(
            color:widget.value==widget.groupvalue ? 
              Colors.white :
              Colors.blue,
        ) ),
        tileColor: widget.value==widget.groupvalue ?
         Colors.blue : 
         Colors.white,
        onTap: () => widget.onPressed(),
      ),
    );
  }
}