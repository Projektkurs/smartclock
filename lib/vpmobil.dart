//import "package:smartclock/main_header.dart";
import "package:http/http.dart" as http;
//import "package:smartclock/main_header.dart";
import "dart:convert";
import "package:xml/xml.dart";
import "main_header.dart";

const MAXHOURSPERDAY=7;
class Plan{
  final List<List<Lesson?>> lessons;
  final List<XmlDay> days;
  final List<DateTime> freedates;
  Plan(
    this.lessons,
    this.days,
    this.freedates
  );

  static Future<Plan> newplan(String room) async {
    List<XmlDay> days=[(await XmlDay.async(null))!];
    List<List<Lesson?>> lessons=[];
    //get all free days
    List<String> freedaysStrings=[];
      days[0].xml.findAllElements("ft").forEach((node) {freedaysStrings.add(node.text);});
    var freedates=freedays(freedaysStrings);
    DateTime currentday= days[0].date;
    for(int i=0;i<4;i++){
      currentday=nextday(currentday, freedates)!; //the next times needs to exist
      XmlDay? tmpday=await XmlDay.async(currentday);
      if(tmpday==null){
        break;
      }
      days.add(tmpday);
    }
    for(var i in days){
      lessons.add(await roomallocation(i,room));
    }
    return Plan(lessons,days,freedates);
  }
}
class Lesson{
  final int hour;
  final int room;
  final String subject;
  final String teacher;
  final String info;
  final String level; 
  Lesson(
    this.hour,
    this.room,
    this.subject,
    this.teacher,
    this.info,
    this.level
  );
  Lesson.fromxmlnode(XmlNode node):
    hour = int.parse(node.getElement("St")!.text.toString()),
    room = int.parse(node.getElement("Ra")!.text.toString()),
    subject = node.getElement("Fa")!.text.toString(),
    teacher = node.getElement("Le")!.text.toString(),
    info = node.getElement("If")!.text.toString(),
    level = node.parent!.parent!.getElement("Kurz")!.text.toString();

  String printString(){
    return 
"""hour $hour:
  room: $room
  subject: $subject
  teacher: $teacher
  info: $info
  Stufe: $level
""";
  }
}
class XmlDay{
  XmlDocument xml;
  DateTime date; 
  XmlDay(this.xml,this.date);
  
  static Future<XmlDay?> async(DateTime? date) async{
    //vpmobil needs day and month to have two digits; eg. January, 4th -> 01.04
    String pad(int date) => date<10 ? "0$date": date.toString();

    String xmlname = date == null ? "Klassen.xml" : "PlanKl${date.year}${pad(date.month)}${pad(date.day)}.xml";
    http.Response? plan;
    try{
    plan = await http.get(Uri.https("www.stundenplan24.de","/52002736/mobil/mobdaten/$xmlname"),
      headers: {'authorization': "Basic ${base64Encode(utf8.encode('${jsonconfig.vpuser}:${jsonconfig.vppasswd}'))}"});
    }catch(_){
      return null;
    }
    return XmlDay(XmlDocument.parse(plan.body),date?? trim(DateTime.now())); 
  }
}
DateTime trim(DateTime date){
  return DateTime(date.year,date.month,date.day);
}

Future<List<Lesson?>> roomallocation(XmlDay plan, String room)async {
    var rooms = plan.xml.findAllElements("Ra");
    List<XmlNode> filteredrooms=[];
    //todo: room does not exist
    rooms.forEach((node){node.text==room ? filteredrooms.add( node.ancestors.first): "" ;});
    List<Lesson?> lessons=[];
    for(int i=0;i<MAXHOURSPERDAY;i++){
      lessons.add(null);
    }
    //print("test")
    for(var node in filteredrooms){
      lessons[int.parse(node.getElement("St")!.text.toString())-1]=Lesson.fromxmlnode(node);
    }

    return lessons;
}
List<DateTime> freedays(List<String> days){

  DateTime freetodate(String strdate){
    return DateTime(
      int.parse(strdate.substring(0,2))+2000,
      int.parse(strdate.substring(2,4)),
      int.parse(strdate.substring(4,6)));
  }

  List<DateTime> dates=[];

  for(var i in days){
    dates.add(freetodate(i));
  }
  return dates;
}
//returns the next regular school day
DateTime? nextday(DateTime currentday,List<DateTime> freedates){
    for(int i=0;i<60;i++){
      currentday = currentday.add(const Duration(days:1));
      if(currentday.weekday==DateTime.sunday || currentday.weekday==DateTime.saturday)
      {
        //print("wochenende");
        continue;

      }
      if(freedates.contains(currentday)){
        //print("freier Tag");
        continue;
      }
      //print(currentday);
      return currentday;
    }
}

