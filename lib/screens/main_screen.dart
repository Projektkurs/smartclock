/* main_screen.dart - base screen for AppState
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/component/componentconfig.dart';
import 'package:smartclock/main_header.dart';
import 'package:path/path.dart' as p;

class MainScreen extends StatefulWidget
{
  const MainScreen({required super.key,
  required this.appState});
  final AppState appState;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  bool showlines=false;
  bool editmode=false;
  bool firstbuild=true;
  //Key is used for callbacks(scaffholding/callbacks.dart)
  //it mustn't change, as they are saved at various places in the Widget tree
  //exception to this is if the whole widget tree is droped 
  _updatelines() {setState(() {
    showlines=!showlines;
  });}
  Scaffolding? mainscaffolding;
  @override
  Widget build(BuildContext context) {
    //cannot be in initstate as setState should cannot be called there
    if(firstbuild){
      widget.appState.configisload.then((value){
        if(isepaper){
        widget.appState.jsonsave=File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).readAsStringSync();
        }
        firstbuild=false;
        setState(() {});
      });
    }else{
      if(widget.appState.scafffromjson){
          widget.appState.scaffholdingkey=GlobalKey();
          mainscaffolding=Scaffolding.fromJson(jsonDecode(widget.appState.jsonsave),key:widget.appState.scaffholdingkey);
          widget.appState.scafffromjson=false;
        }else{
          mainscaffolding=Scaffolding(key:widget.appState.scaffholdingkey,
          gconfig:GeneralConfig(
          2<<40,//arbitrary value for flex
          //should be high as to have many to have smooth transition
          ScaffoldingConfig()),
          direction: true, subcontainers: widget.appState.maincontainers,showlines:showlines);
        }
    }
    if(isepaper){
      return Scaffold(
      key:widget.appState.scaffoldkey,
      body: Center(
        child: Stack(children: [
          // menu laying on top of the main Scaffholding
          Flex(direction: Axis.horizontal,
            children: [mainscaffolding ?? Container()]),
          //widget.appState.menu
        ])
      ));
    }else{
    return Scaffold(
      key:widget.appState.scaffoldkey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('add Container'),
              onTap: widget.appState.addContainer,
            ),
            ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('remove Container'),
              onTap: widget.appState.removeContainer,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const  Text('editmode'),
              trailing: Switch(
                onChanged: (bool val){Navigator.of(context).pop();},
                value: editmode,),
              onTap: (){setState((){editmode=!editmode;});
              Navigator.of(context).pop();}
            ),
            ListTile(
              leading: const Icon(Icons.view_array_outlined),
              title: const Text('resize widgets'),
              onTap: () {
                _updatelines();
                //Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const  Text('Settings'),
              onTap: () {//Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/settingsScreen');},
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const  Text('save'),
              onTap: (){
                widget.appState.jsonsave=jsonEncode(mainscaffolding);
                debugPrint(widget.appState.jsonsave);
                jsonconfig.updateconfig(jsonconfig.defaultconfig,widget.appState.jsonsave);
                post(
                  Uri(scheme:'http',host: jsonconfig.epaperIP,path:'/config',port: jsonconfig.epaperPort),
                  body: widget.appState.jsonsave);
                }
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const  Text('load'),
              onTap: (){setState(() {
                debugPrint("apply Config");
                widget.appState.maincontainers=jsonDecode(widget.appState.jsonsave)['subcontainers'];
                widget.appState.scafffromjson=true;});
              }
            ),
            ListTile(
              leading: const Icon(Icons.reset_tv),
              title: const  Text('reset save'),
              onTap: (){setState(() {
                widget.appState.jsonsave=emptyjsonconfig;
                debugPrint(widget.appState.jsonsave);
                jsonconfig.updateconfig(jsonconfig.defaultconfig,widget.appState.jsonsave);
                post(
                  Uri(scheme:'http',host: jsonconfig.epaperIP,path:'/config',port: jsonconfig.epaperPort),
                  body: widget.appState.jsonsave);});
                widget.appState.maincontainers=jsonDecode(widget.appState.jsonsave)['subcontainers'];
                widget.appState.scafffromjson=true;
              }
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(children: [
          // menu laying on top of the main Scaffholding
          Flex(direction: Axis.horizontal,
            children: [mainscaffolding ?? Container()]),
          widget.appState.menu
        ])
      ),
      //start: Buttons in the bottom right to add/remove Containers 
      //and enable/disable resizelines
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: FloatingActionButton(
              //random tag, not refferenced 
              heroTag: "dkjfhdlkfjdhflkjhflhslakfhuoewqzrq2d",
              onPressed: () => widget.appState.scaffoldkey.currentState!.openDrawer(),
              tooltip: 'menu',
              child: const Icon(Icons.menu),
            )
          ),
        ]
      )//end: Buttons
    ); 
    }
  }
}

