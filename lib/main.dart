/* main.dart - entry point
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:smartclock/screens/settings_screen.dart';
import 'screens/main_screen.dart';

late String supportdir;
late JsonConfig jsonconfig;
void main() 
{
  //tz.initializeTimeZones();
  runApp(const Entry());
}
GeneralConfig globalgconf=GeneralConfig.createGeneral();
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
  //main menu laying on top the top of Widget stack
  late Popup menu=Popup();
  //own method to parse up a config to be configured by menu
  configMenuMainParse(List<Key> key,GeneralConfig config,double width,double height,void Function(VoidCallback fn) configsetState){
    //menu.componenttype=type;
    menu.componentconfig=config;
    menu.openMenu(1);
    menu.configsetState=configsetState;
  }
  //textcontroller
  //number of Widgets by the first scaffholding
  int maincontainers = 1;
  addContainer() {setState(() {
    maincontainers<6 ? maincontainers++: null;});}
  removeContainer() {setState(() {
    maincontainers>1 ? maincontainers--: null ;});}

  //changes variable "enabled" of every resizeline  -> see resizeline.dart
  bool _showlines=false;

  late Future<bool> configisload;
  @override
  void initState() {
    super.initState();
    configmenu=configMenuMainParse;
    if(isepaper){
      epaperUpdateInterrupt();
    }
    Future<bool> loadconfig() async{
      supportdir = isepaper ? "./" :(await getApplicationSupportDirectory()).path;
      await Directory(p.join(supportdir,"configs")).create();
      //var directory = await Directory('./data/configs').create(recursive: true);
      if( await File(p.join(supportdir,'config')).exists()){
        debugPrint("Config found at ${p.join(supportdir,'config')}");
      }else{
        debugPrint("No Config found, writing new on to ${p.join(supportdir,'config')}");
        await File(p.join(supportdir,'config')).writeAsString(jsonEncode(JsonConfig()));
      }
      String tmpjsonstr=await File(p.join(supportdir,'config')).readAsString();
      try{
        jsonconfig=JsonConfig.fromJson(jsonDecode(tmpjsonstr));
      }on FormatException{
        debugPrint("ERROR: jsonconfig is corrupted, generating new one");
        jsonconfig=JsonConfig();
        File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
      }
      if(jsonconfig.defaultconfig==""){
        debugPrint("no Widget tree config found, will use the default init as config");
        SchedulerBinding.instance.scheduleFrameCallback((Duration duration){
          //jsonsave=jsonEncode(mainscaffolding);
          jsonsave=emptyjsonconfig;
          jsonconfig.addconfig("defaultconfig", jsonsave);
          jsonconfig.defaultconfig="defaultconfig";
          File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
          debugPrint("new jsonsave:$jsonsave");
        });
      }else{
        if(await File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).exists()){
          debugPrint("applyingconfig: ${p.join(supportdir,'configs',jsonconfig.defaultconfig)}");
          jsonsave=await File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).readAsString();
          debugPrint("jsonsave:$jsonsave");          
        }else{
          jsonconfig.configs.remove(jsonconfig.defaultconfig);
          jsonconfig.defaultconfig="";
        }
        if(jsonDecode(jsonsave)==null){
          debugPrint("Error: the json file is corrupted or the versions are not compatible");
          await File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).delete();
          await File(p.join(supportdir,'config')).delete();
        }
        maincontainers= jsonDecode(jsonsave)['subcontainers'];
        scafffromjson=true;
      }
      //needs to be initialized at the point where settings is opened
      return true; }
    configisload= loadconfig();
    if(isepaper){
          updatescreen()async{
          Future.delayed(const Duration(minutes: 5)).then((value)async {
            setState(() {
            print("apply Config");
              jsonsave=File('./configs/defaultconfig').readAsStringSync();
              maincontainers=jsonDecode(jsonsave)['subcontainers'];
              scafffromjson=true;
            File('config').writeAsString(jsonEncode(jsonconfig));
            updatescreen();
        });
      });
      }
      SchedulerBinding.instance.scheduleFrameCallback((Duration duration){updatescreen();});
    }
  }

  String jsonsave="";
  //Key is used for callbacks(scaffholding/callbacks.dart)
  //it mustn't change, as they are saved at various places in the Widget tree
  //exception to this is if the whole widget tree is droped 
  GlobalKey<ScaffoldingState> scaffholdingkey=GlobalKey();
  GlobalKey<ScaffoldState> scaffoldkey=GlobalKey(); 
  GlobalKey mainscreenkey=GlobalKey();
  GlobalKey settingsscreenkey=GlobalKey();
  Scaffolding? mainscaffolding;
  bool scafffromjson=false;
  bool firstbuild=true;
  @override
  Widget build(BuildContext context) 
  {
    debugPrint("firstbuild:$firstbuild");

  return MaterialApp(
    home: MainScreen(
    key:mainscreenkey,
    appState: this),
    routes: <String, WidgetBuilder> {
      '/mainScreen': (BuildContext context) => MainScreen(
        key:mainscreenkey,
        appState: this),
      '/settingsScreen': (BuildContext context) => SettingsScreen(
    key:settingsscreenkey,
    appState: this),
    }
  );
  }
}