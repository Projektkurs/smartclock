/* message.dart - framework to communicate between epaper and device
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';

mixin message{
  File fifo=File('./updatefifo');
  void setState(void Function() fn);
  late String jsonsave;
  late int _maincontainers;
  late bool scafffromjson;

  epaperUpdateInterrupt() async{
    Future<String> fifocontent=fifo.readAsString();
    fifocontent.then((message){
      setState(() {
        debugPrint("apply Config");
        jsonsave=File('./config.json').readAsStringSync();
        _maincontainers=jsonDecode(jsonsave)['subcontainers'];
        scafffromjson=true;
      });
    epaperUpdateInterrupt();});
  }
}