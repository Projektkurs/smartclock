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
        debugPrint("applyingconfig: ${p.join(supportdir,'configs',jsonconfig.defaultconfig)}");
        jsonsave=await File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).readAsString();
        debugPrint("jsonsave:$jsonsave");
        if(jsonDecode(jsonsave)==null){
          debugPrint("Error: the json file is corrupted or the versions are not compatible");
          //await File(p.join(supportdir,'configs',jsonconfig.defaultconfig)).delete();
          //File(p.join(supportdir,'config'));
        }
        maincontainers=jsonDecode(jsonsave)['subcontainers'];
        scafffromjson=true;
      }
      //needs to be initialized at the point where settings is opened
      return true;    }
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
  final GlobalKey mainscreenkey=GlobalKey();
  final GlobalKey settingsscreenkey=GlobalKey();
  Scaffolding? mainscaffolding;
  bool scafffromjson=false;
  bool firstbuild=true;
  @override
  Widget build(BuildContext context) 
  {
    print("firstbuild:$firstbuild");
   // return MainScreen(
   //   key:mainscreenkey,
   //   appState: this);

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

    /*TextField(
  obscureText: false,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'epaper IP',
  ),
)*/