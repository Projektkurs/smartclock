import 'package:smartclock/main_header.dart';
import 'package:smartclock/vpmobil.dart' as vp;

class Vertretungsplan extends Component {
  @override
  Vertretungsplan({
    required Key key,
    required GeneralConfig gconfig,
  }) : super(key: key, gconfig: gconfig);

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
    
    //does this create a call stack overflow?
    updateplan()async{
      vplan=await vp.Plan.newplan(widget.gconfig.cconfig.raum);
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
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Belegungsplan ${widget.gconfig.cconfig.raum}",
          textScaleFactor: 2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          textDirection: TextDirection.ltr,
          border: TableBorder.all(width: 1.0, color: Colors.black),
          children: createcompletetable()
        ),
      ),
    ]));
  }
}


/*Widget build(BuildContext context) {
  return
}*/