/* main.dart - entry point
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/message.dart';

const bool isepaper=false;
void main() 
{
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

  @override
  void initState() {
    super.initState();
    configmenu=configMenuMainParse;
    if(isepaper){
      epaperUpdateInterrupt();
    }
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
  @override
  Widget build(BuildContext context) 
  {
    mainscaffolding=Scaffolding(key:scaffholdingkey,
      gconfig:GeneralConfig<EmptyConfig>(
      2<<40,//arbitrary value for flex 
      //should be high as to have many to have smooth transition
      EmptyConfig(),
      Scaffolding),
      direction: true, subcontainers: _maincontainers,showlines:_showlines);
    if(scafffromjson){
      scaffholdingkey=GlobalKey();
      mainscaffolding=Scaffolding.fromJson(jsonDecode(jsonsave),key:scaffholdingkey);
      scafffromjson=false;
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
                var response = post(
                  Uri(scheme:'http',host: 'localhost',path:'/config',port: 8000),
                  body: jsonsave);}
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
            children: [mainscaffolding!]),
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
