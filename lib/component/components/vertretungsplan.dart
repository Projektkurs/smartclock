import 'package:smartclock/main_header.dart';

class Vertretungsplan extends Component {
  @override
  Vertretungsplan({
    required Key key,
    required GeneralConfig gconfig,
    //required this.resizeWidget,
    //required configMenu,
  }) : super(key: key, gconfig: gconfig);
  //: super(key: key,gconfig:gconfig,configMenu:configMenu);
//final Function resizeWidget;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> tmpconf = super.toJson();
    return tmpconf;
  }

  Vertretungsplan.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromjson(json['gconfig'],
                VertretungsplanConfig.fromJson(json["gconfig"]["cconfig"])));

  //final GeneralConfig<EmptyComponentConfig> gconfig;

  @override
  State<Vertretungsplan> createState() => VertretungsplanState();
}

class VertretungsplanState extends State<Vertretungsplan>
    with ComponentBuild<Vertretungsplan> {
  @override
  void initState() {
    defaultfirstbuild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return componentbuild(Column(children: <Widget>[
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Belegungsplan",
          textScaleFactor: 2,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          textDirection: TextDirection.ltr,
          border: TableBorder.all(width: 1.0, color: Colors.black),
          children: [
            TableRow(children: [
              Text("", textScaleFactor: 1.5),
              Text("Montag", textScaleFactor: 1.5),
              Text("Dienstag", textScaleFactor: 1.5),
              Text(
                "Mittwoch",
                textScaleFactor: 1.5,
              ),
              Text(
                "Donnerstag",
                textScaleFactor: 1.5,
              ),
              Text(
                "Freitag",
                textScaleFactor: 1.5,
              ),
            ]),
            TableRow(children: [
              Text("1. Stunde", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
            ]),
            TableRow(children: [
              Text("2. Stunde", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
            ]),
            TableRow(children: [
              Text("3. Stunde", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
            ]),
            TableRow(children: [
              Text("4. Stunde", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
            ]),
            TableRow(children: [
              Text("5. Stunde", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
            ]),
            TableRow(children: [
              Text("6. Stunde", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
              Text("", textScaleFactor: 1.5),
            ]),
          ],
        ),
      ),
    ]));
  }
}


/*Widget build(BuildContext context) {
  return
}*/