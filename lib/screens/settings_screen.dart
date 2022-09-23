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
  @override
  void initState() {
    super.initState();
    _textcontroller = TextEditingController(text: widget.appState.jsonconfig.epaperIP);
    _porttextcontroller = TextEditingController(text: widget.appState.jsonconfig.epaperPort.toString());
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
        appBar: AppBar(
          leading: Container(),
          title: const Text('Settings'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/mainScreen");
          }),
        body:Column(children: [
          TextField(
            controller: _textcontroller,
            onSubmitted: (String value){
              widget.appState.jsonconfig.epaperIP=value;
              File(p.join(supportdir,'config')).writeAsString(jsonEncode(widget.appState.jsonconfig));
              
            },  
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'epaper IP',),
          ),
          TextField(
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
              widget.appState.jsonconfig.epaperPort=tmpport ?? widget.appState.jsonconfig.epaperPort;
              File(p.join(supportdir,'config')).writeAsString(jsonEncode(widget.appState.jsonconfig));
            },  
            decoration: InputDecoration(
              errorText: _validport ? null : (){return "Invalid port";}(),
              border: const OutlineInputBorder(),
              labelText: 'epaper Port',),)
        ]),
    );
  }
}