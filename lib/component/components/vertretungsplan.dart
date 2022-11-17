import 'package:smartclock/main_header.dart';
import 'package:smartclock/vpmobil.dart' as vp;

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
  vp.Plan? vplan;
  @override
  void initState() {
    defaultfirstbuild();
    super.initState();
    
    //does this create a stack overflow?
    updateplan()async{
      vplan=await vp.Plan.newplan("304");
      if(widget.built){
        setState(() {});
        debugPrint("plan loaded");
        Future.delayed(const Duration(minutes: 5)).then((value)async {updateplan();});
      }
    }
  SchedulerBinding.instance.scheduleFrameCallback((Duration duration){updateplan();});
  
  }
  Widget hourformat(vp.Lesson? lesson ){
    if(lesson==null){
      return const Text("");
    }else{
      var note=lesson.info=="" ? "": "\nInfo:${lesson.info}"; 
      return Text("${lesson.level}: ${lesson.subject}, ${lesson.teacher}$note",style: Theme.of(context).textTheme.titleMedium);
    }
  }
  String getweekday(DateTime date){
    switch(date.weekday){
      case(1): return "Mo";
      case(2): return "Di";
      case(3): return "Mi";
      case(4): return "Do";
      case(5): return "Fr";
      case(6): return "Sa";
      case(7): return "So";
      default: return "";
      }
  }
  String getday(DateTime date){
    if(date==vp.trim(DateTime.now())){
      return "Heute";
    }
    if(date==vp.trim(DateTime.now().add(const Duration(days: 1)))){
      return "Morgen";
    }
    return "${getweekday(date)} der ${date.day}. ${date.month}";
  }
  TableRow onecollumn(int hour ){
    List<Widget> text=[Text("$hour. Stunde",style: Theme.of(context).textTheme.titleLarge)];
    for(var i in vplan!.lessons){
      text.add(hourformat(i[hour]));
    }
    return TableRow(children: text);
  }
  List<TableRow> createcompletetable(){
    if(vplan==null){
      return [];
    }
    List<Widget>firstrow=[Text("")];
    for(int i =0;i<5;i++){
      firstrow.add(Text(getday(vplan!.days[i].date),textScaleFactor: 1.5,));
    }
    List<TableRow> tables=[
      TableRow(children: firstrow)];
    for(int i=0;i<7;i++){
      tables.add(onecollumn(i));
    }
    return tables;
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
          children: createcompletetable()/*[createcompletetable()
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
          ],*/
        ),
      ),
    ]));
  }
}


/*Widget build(BuildContext context) {
  return
}*/