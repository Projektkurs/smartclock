/* config.dart - class which saves options convertable to json file
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import "package:path/path.dart" as p;
import "package:smartclock/main_header.dart";

class JsonConfig{
  //configs
  String defaultconfig="";
  List<String> configs=[];
  
  //epaper
  bool enableepaper=true;
  String epaperIP="localhost";
  int epaperPort=8000;
  int epaperRefreshtime=60;//in seconds

  //vpmobil
  String vpuser="";
  String vppasswd="";


  //theme
  
  JsonConfig();
  upload() async{
    post(
      Uri(scheme:'http',host: epaperIP,path:'/generalconfig',port: epaperPort),
        body: jsonEncode(this));
  }
  Future<int> addconfig(String name,String json) async{
    if(await File(p.join(supportdir,"configs",name)).exists()){
      debugPrint("${p.join(supportdir,"configs",name)} already exists");
      return 1;
    }
    //ensure that it is not a path
    configs.add(name);
    debugPrint("creating config in file ${p.join(supportdir,"configs",name)}");
    await File(p.join(supportdir,"configs",name)).writeAsString(json);
    return 0;
  }

  Future<int> removeconfig(String name) async{
    return configs.remove(name) ? 0 : 1;
  }

  Future<int> renameconfig(String oldname,String newname) async{
    if(configs.contains(oldname)){
      debugPrint("ERROR: $oldname is not a name of a config");
      return 1;
    }
    configs[configs.indexOf(oldname)]=newname;
    return 0;
  }

  Future<int> updateconfig(String name,json) async{
    await File(p.join(supportdir,"configs",name)).writeAsString(json);
    return 0;
  }

  Map<String, dynamic> toJson() => {
    "defaultconfig":defaultconfig,
    "configs": configs,

    "enableepaper":enableepaper,
    "epaperIP":epaperIP,
    "epaperPort":epaperPort,
    "epaperRefreshtime":epaperRefreshtime,

    "vpuser":vpuser,
    "vppasswd":vppasswd
  };
  
  JsonConfig.fromJson(Map<String, dynamic> json)
  : defaultconfig=json["defaultconfig"],
    configs=List<String>.from(json["configs"]),
    
    enableepaper=json["enableepaper"] ?? true,
    epaperIP=json["epaperIP"] ?? "localhost",
    epaperPort=json["epaperPort"] ?? 8000,
    epaperRefreshtime=json["epaperRefreshtime"] ?? 10,

    vpuser=json["vpuser"] ?? "",
    vppasswd=json["vppasswd"] ?? ""
  ;
}