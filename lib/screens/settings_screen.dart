/* settings_screen.dart - settings Menu for general use
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:path/path.dart' as p;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required super.key,
  required this.appState});
  final AppState appState;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _textcontroller;
  late TextEditingController _porttextcontroller;
  late TextEditingController _vpusertextcontroller;
  late TextEditingController _vppasswdtextcontroller;
  @override
  void initState() {
    super.initState();
    _textcontroller = TextEditingController(text: jsonconfig.epaperIP);
    _vpusertextcontroller = TextEditingController(text: jsonconfig.vpuser);
    _vppasswdtextcontroller = TextEditingController(text: jsonconfig.vppasswd);
    _porttextcontroller = TextEditingController(text: jsonconfig.epaperPort.toString());
  }
  @override
  void dispose() {
    _textcontroller.dispose();
    _porttextcontroller.dispose();
    super.dispose();
  }
  bool _validport=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //experimental 
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/mainScreen");
          }),
        body:
        ListView(
        children:[
        ExpansionTile(
          title: const Text("E-Paper"),
        children:[
          Container(
            margin: const EdgeInsets.all(8),
            child: 
          TextField(
            controller: _textcontroller,
            onSubmitted: (String value){
              jsonconfig.epaperIP=value;
              debugPrint(jsonEncode(jsonconfig));
              File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
              
            },  
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'epaper IP',),
          )),
          Container(
            margin: const EdgeInsets.all(8),
            child: TextField(
            keyboardType: TextInputType.number,
            controller: _porttextcontroller,
            onSubmitted: (String value){
              int? tmpport=int.tryParse(value);
              if(tmpport==null){
                setState((){_validport=false;});
              }else{
                if(tmpport<=0 || tmpport>2<<15){
                  setState((){_validport=false;});
                  tmpport=null;
                }
                else{
                  setState((){_validport=true;});
                }
              }
              jsonconfig.epaperPort=tmpport ?? jsonconfig.epaperPort;
              debugPrint(jsonEncode(jsonconfig));
              File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
              jsonconfig.upload();
            },  
            decoration: InputDecoration(
              errorText: _validport ? null : (){return "Invalid port";}(),
              border: const OutlineInputBorder(),
              
              labelText: 'epaper Port',),)
    )]),
              Container(
            margin: const EdgeInsets.all(8),
            child: 
          TextField(
            controller: _vpusertextcontroller,
            onSubmitted: (String value){
              jsonconfig.vpuser=value;
              debugPrint(jsonEncode(jsonconfig));
              File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
              jsonconfig.upload();
              
            },  
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'vpmobil user',),
          )),
                    Container(
            margin: const EdgeInsets.all(8),
            child: 
          TextField(
            controller: _vppasswdtextcontroller,
            onSubmitted: (String value){
              jsonconfig.vppasswd=value;
              debugPrint(jsonEncode(jsonconfig));
              File(p.join(supportdir,'config')).writeAsString(jsonEncode(jsonconfig));
              jsonconfig.upload();
            },  
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'vpmobil password',),
          )),
    ],
    ));
  }
}