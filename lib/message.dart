/* message.dart - framework to communicate between epaper and device
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:path/path.dart' as p;

mixin message{
  File fifo=File('./updatefifo');
  void setState(void Function() fn);
  late String jsonsave;
  late int maincontainers;
  late bool scafffromjson;

  epaperUpdateInterrupt() async{
    Future<String> fifocontent=fifo.readAsString();
    fifocontent.then((message){
      setState(() {
        //if(message=="config"){
        print("apply Config");
        jsonsave=File('./configs/defaultconfig').readAsStringSync();
        maincontainers=jsonDecode(jsonsave)['subcontainers'];
        scafffromjson=true;
        //}else if(message=="generalconfig"){
        //jsonconfig=jsonDecode(message);
        File('config').writeAsString(jsonEncode(jsonconfig));
        //}
      });
    epaperUpdateInterrupt();});
  }
}