/* menuoptions.dart - mixin for quick format menu 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
mixin Menuoptions
{
  BuildContext get context;
  Widget singleMenu(child){
  return Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width*.07,
          vertical: MediaQuery.of(context).size.height*.07
        ),
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border:Border.all(width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))
        ),
        alignment: Alignment.center,
        child: child
    );
  }
}