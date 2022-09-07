/* main.dart - entry point
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'dart:io';

import 'main_header.dart';

void main() 
{
  runApp(const Entry());
}
//Entry is used to ensure the theme and text direction is inherited on all widgets
class Entry extends StatelessWidget 
{
  const Entry({Key? key}) : super(key: key);
  static const title = 'SmartClock';

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

class AppState extends State<App> 
{
  late Menu menu=Menu(function: _addContainer);
  configMenuMainParse(List<Key> key,Type type,ComponentConfig config){
    print(config);
    menu.componenttype=type;
    menu.componentconfig=config;
    print(menu.componentconfig);
    print(key);
    
  }


  int _maincontainers = 1; // defines the number of rows / columns of the first Scaffold
  _addContainer() {setState(() {
    _maincontainers<6 ? _maincontainers++: null;});}
  _removeContainer() {setState(() {
    _maincontainers>0 ? _maincontainers--: null ;});}

  bool _showlines=false;
  _updatelines() {setState(() {
    _showlines=!_showlines;
  });}
  Key Scaffholdingkey=GlobalKey();
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          // menu laying on top of the main Scaffholding
          Flex(direction: Axis.horizontal,
            children: [Scaffholding(key:Scaffholdingkey,
              config:ComponentConfig<ScaffholdingConfig>(Theme.of(context),2<<40,ScaffholdingConfig(),Scaffholding) ,notconfigMenu: (){},//(Theme.of(context) as ComponentConfig),
              //key:GlobalKey(), 
            direction: true, subcontainers: _maincontainers,showlines:_showlines,
            parentConfigMenu: configMenuMainParse)]),
          menu
        ])
      ),
      floatingActionButton: Column(
        //two buttons at the downer right corner to add / remove a container
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            
            child: FloatingActionButton
            (
              onPressed: _updatelines,
              tooltip: 'lines',
              child: const Icon(Icons.add),
            )
          ),
          Flexible(
            
            child: FloatingActionButton
            (
              onPressed: _addContainer,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          ),
          Flexible(
            child: FloatingActionButton(
              onPressed: _removeContainer,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            )
          )
        ]
      )
    ); 
  } 
}
