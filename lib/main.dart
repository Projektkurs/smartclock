/* main.dart - entry point
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


const bool isepaper=false;
late String supportdir;
void main() 
{
  //tz.initializeTimeZones();
  runApp(const Entry());
}
//Entry class, used to set default theme
class Entry extends StatelessWidget 
{
  const Entry({Key? key,} ) : super(key: key);
  static const title = 'SmartClock';
  //will be used later to switch between end-user mode and embeddded


  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(title: title),
    );
  }
}

class App extends StatefulWidget 
{
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  AppState createState() => AppState();
}


class AppState extends State<App> with message
{
  File fifo=File('./updatefifo');
  late JsonConfig jsonconfig;
  //main menu laying on top the top of Widget stack
  late Popup menu=Popup();
  //own method to parse up a config to be configured by menu
  configMenuMainParse(List<Key> key,Type type,GeneralConfig config,double width,double height){
    menu.componenttype=type;
    menu.componentconfig=config;
    menu.openMenu(1);
  }

  //number of Widgets by the first scaffholding
  int _maincontainers = 1;
  _addContainer() {setState(() {
    _maincontainers<6 ? _maincontainers++: null;});}
  _removeContainer() {setState(() {
    _maincontainers>1 ? _maincontainers--: null ;});}

  //changes variable "enabled" of every resizeline  -> see resizeline.dart
  bool _showlines=false;
  _updatelines() {setState(() {
    _showlines=!_showlines;
  });}

  late Future<bool> configisload;
  @override
  void initState() {
    super.initState();
    configmenu=configMenuMainParse;
    if(isepaper){
      epaperUpdateInterrupt();
    }
    Future<bool> loadconfig() async{
      supportdir = (await getApplicationSupportDirectory()).path;
      Directory(p.join(supportdir,"configs")).create();
      //var directory = await Directory('./data/configs').create(recursive: true);
      if( await File(p.join(supportdir,'config')).exists()){
        debugPrint("Config found at ${p.join(supportdir,'config')}");
      }else{
        debugPrint("No Config found, writing new on to ${p.join(supportdir,'config')}");
        await File(p.join(supportdir,'config')).writeAsString(jsonEncode(JsonConfig()));
      }

      jsonconfig=JsonConfig.fromJson(jsonDecode(await File(p.join(supportdir,'config')).readAsString()));
      if(jsonconfig.defaultconfig==""){
        debugPrint("no Widget tree config found, will use the default init as config");
        SchedulerBinding.instance.scheduleFrameCallback((Duration duration){
          jsonsave=jsonEncode(mainscaffolding);
          jsonconfig.addconfig("defaultconfig", jsonsave);
          jsonconfig.defaultconfig="defaultconfig";
          File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
        });
      }else{
        print("applyingconfig: ${p.join(supportdir,'configs',jsonconfig.defaultconfig)}");
        jsonsave=await File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).readAsString();
        print("jsonsave:$jsonsave");
        if(jsonDecode(jsonsave)==null){
          debugPrint("Error: the json file is corrupted or the versions are not compatible");
        }
        _maincontainers=jsonDecode(jsonsave)['subcontainers'];
        scafffromjson=true;
      }
      return true;
    }
    configisload= loadconfig();
  }
  //editing mode
  bool _editmode=false;
  String jsonsave="";
  //Key is used for callbacks(scaffholding/callbacks.dart)
  //it mustn't change, as they are saved at various places in the Widget tree
  //exception to this is if the whole widget tree is droped 
  GlobalKey<ScaffoldingState> scaffholdingkey=GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldkey=GlobalKey(); 
  Scaffolding? mainscaffolding;
  bool scafffromjson=false;
  bool firstbuild=true;
  @override
  Widget build(BuildContext context) 
  {
    print("firstbuild:$firstbuild");
    if(firstbuild){
      configisload.then((value){
        firstbuild=false;
        setState(() {});
      });
    }else{
      if(scafffromjson){
        scaffholdingkey=GlobalKey();
        mainscaffolding=Scaffolding.fromJson(jsonDecode(jsonsave),key:scaffholdingkey);
        scafffromjson=false;
      }else{
        mainscaffolding=Scaffolding(key:scaffholdingkey,
        gconfig:GeneralConfig<EmptyConfig>(
        2<<40,//arbitrary value for flex 
        //should be high as to have many to have smooth transition
        EmptyConfig(),
        Scaffolding),
        direction: true, subcontainers: _maincontainers,showlines:_showlines);
      }
    }
    return isepaper ? 
    Column (children:[mainscaffolding!]) : 
    Scaffold(
      key:scaffoldkey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('add Container'),
              onTap: _addContainer,
            ),
            ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('remove Container'),
              onTap: _removeContainer,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const  Text('editmode'),
              trailing: Switch(
                onChanged: (bool val){Navigator.of(context).pop();},
                value: _editmode,),
              onTap: (){setState((){_editmode=!_editmode;});
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
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const  Text('save'),
              onTap: (){
                jsonsave=jsonEncode(mainscaffolding);
                debugPrint(jsonsave);
                jsonconfig.updateconfig(jsonconfig.defaultconfig,jsonsave);
                post(
                  Uri(scheme:'http',host: 'localhost',path:'/config',port: 8000),
                  body: jsonsave);
              }
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const  Text('load'),
              onTap: (){setState(() {
                debugPrint("apply Config");
                _maincontainers=jsonDecode(jsonsave)['subcontainers'];
                scafffromjson=true;
              });
                },
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(children: [
          // menu laying on top of the main Scaffholding
          Flex(direction: Axis.horizontal,
            children: [mainscaffolding ?? Container()]),
          menu
        ])
      ),
      //start: Buttons in the bottom right to add/remove Containers 
      //and enable/disable resizelines
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: FloatingActionButton(
              onPressed: () => scaffoldkey.currentState!.openDrawer(),
              tooltip: 'menu',
              child: const Icon(Icons.menu),
            )
          ),
        ]
      )//end: Buttons
    ); 
  } 
}
