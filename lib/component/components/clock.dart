/* clock.dart - a clock based upon the dart-libary: "analog_clock"
 *
 * Copyright 2022 by Béla Wohlers <bela.wohlers@gmx.de>
 *
*/

import 'package:smartclock/main_header.dart';


// Creates an analog or digital clock
class Clock extends Component
{
  final DateTime? datetime;
  final bool isLive;
  @override
   Clock({
    required Key key,
    required GeneralConfig gconfig,
    this.datetime,
    isLive})
    : isLive = isLive ?? (datetime == null),
      super(key: key,gconfig:gconfig);

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> tmpconf=super.toJson();
    tmpconf['datetime']=datetime;
    tmpconf['isLive']=isLive;
    return tmpconf;  
  }

  Clock.fromJson(Map<String, dynamic> json)
    :datetime=json['datetime'],
    isLive =json['isLive'],
    super(
      key:GlobalKey(),
      gconfig: GeneralConfig.fromjson(
        json['gconfig'],ClockConfig.fromJson(json["gconfig"]["cconfig"])
      )
    );

  @override
  State<Clock> createState() => _AnalogClockState(); 
}

class _AnalogClockState extends State<Clock> with ComponentBuild<Clock>
{
  late DateTime initialDatetime; // to keep track of time changes
  late DateTime datetime;
  Duration updateDuration = isepaper ? const Duration(minutes: 1): const Duration(seconds: 1); // repaint frequency
  _AnalogClockState();
  @override
  initState()
  {
    datetime = widget.datetime ?? DateTime.now();
    initialDatetime = widget.datetime ?? DateTime.now();
    defaultfirstbuild();
    super.initState();
    if (widget.isLive) {
      // update clock every second or minute based on the secondhand's visibility.
      Timer.periodic(updateDuration, updateTimer);
    }
  }

  updateTimer(Timer timer)
  {
    if (mounted) {
      datetime = initialDatetime.add((const Duration(seconds: 1)) * timer.tick);
      setState(() {});
    }
  }

  

  @override
  Widget build(BuildContext context)
  {
    return componentbuild(Container(
        constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
        child: Center(
            child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter:
                    ClockPainter(cconf: (widget.gconfig.cconfig as ClockConfig), datetime: datetime)))));
  }
}

//Painter for the AnalogClock
class ClockPainter extends CustomPainter
{
  DateTime datetime;
  ClockConfig cconf;
  ClockPainter({required this.cconf, required this.datetime});

  //draws an analog clock
  analogPaint(Canvas canvas, Size size)
  {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX,
        centerY); //contains the smallest distance from center - to border

    DateTime dateTimeIn12 = datetime;
    datetime.hour > 11
        ? dateTimeIn12.add(const Duration(hours: -12))
        : dateTimeIn12 = datetime;

    //paint style etc...
    final outerRing = Paint()
      ..color = isepaper ? const Color.fromARGB(255, 128, 128, 128):  cconf.outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 100;

    final innerRing = Paint()
      ..style = PaintingStyle.fill
      ..color = isepaper ? Colors.white : cconf.backgroundColor;

    final hourIndicator = Paint()
      ..strokeWidth = radius / 25
      ..color = isepaper ? Colors.black : cconf.indicatorColor;
    final minuteIndicator = Paint()
      ..color = isepaper ? Colors.black : cconf.indicatorColor
      ..strokeWidth = radius / 100;


    //provides the Offset for the clockhands
    Offset handOffset(
        {bool secondHand = false,
        bool hourHand = false,
        bool minuteHand = false,
        bool inner = false}) {
      double x = radius;
      double y = radius;
      double radiant = 0; //the radiant is the value used to convert the time in an angel for the clockhands
      late double innerShift;
      late double outerShift;
      if (hourHand) {
        innerShift = cconf.hourLength1 * radius;
        outerShift = cconf.hourLength2 * radius;
        radiant = (dateTimeIn12.hour + datetime.minute / 60) * (pi / 6);
      } else if (minuteHand) {
        innerShift = cconf.minLength1 * radius;
        outerShift = cconf.minLength2 * radius;
        radiant = datetime.minute  * (pi / 30);
      } else if (secondHand) {
        innerShift = cconf.secLength1 * radius;
        outerShift = cconf.secLength2 * radius;
        radiant = (datetime.second) * (pi / 30);
      }

      //sets the x-y variable for the Offset depending on which side of the hand is calculated
      if (inner) {
        x = centerX - innerShift * sin(radiant);
        y = centerY + innerShift * cos(radiant);
      } else {
        x = centerX + outerShift * sin(radiant);
        y = centerY - outerShift * cos(radiant);
      }

      return Offset(x, y);
    }

    // draws the time indicators
    drawIndicators()
    {
      for (int i = 1; i <= 60; i++) {
        var directionX = cos(i * (pi / 30));
        var directionY = sin(i * (pi / 30));
        if (i % 5 == 0) {
          canvas.drawLine(
              Offset(centerX + (radius - radius * 0.05) * directionX,
                  centerY + (radius - radius * 0.05) * directionY),
              Offset(centerX + (radius - radius * 0.2) * directionX,
                  centerY + (radius - radius * 0.2) * directionY),
              hourIndicator);
        } else {
          canvas.drawLine(
              Offset(centerX + (radius - radius * 0.05) * directionX,
                  centerY + (radius - radius * 0.05) * directionY),
              Offset(centerX + (radius - radius * 0.17) * directionX,
                  centerY + (radius - radius * 0.17) * directionY),
              minuteIndicator);
        }
      }
    }

    drawHourHand()
    {
      canvas.drawLine(handOffset(hourHand: true),
          handOffset(hourHand: true, inner: true), Paint()..color= isepaper ? Colors.black : cconf.hourColor..strokeWidth=radius/26);
    }

    void drawMinuteHand()
    {
      canvas.drawLine(
          handOffset(minuteHand: true),
          handOffset(minuteHand: true, inner: true),
          Paint()..strokeWidth = radius / 40..color=isepaper ? Colors.black : cconf.minColor);
    }

    void drawSecondHand()
    {
      canvas.drawLine(
          handOffset(secondHand: true),
          handOffset(secondHand: true, inner: true),
          Paint()
            ..strokeWidth = radius / 70
            ..color = Colors.red);
    }

    //paint
    canvas.drawCircle(center, radius, innerRing); //draws clock background
    canvas.drawCircle(center, radius, outerRing); //draws outline

    drawIndicators(); //draws the time Hand
    drawHourHand(); //draws the hour Hand
    drawMinuteHand(); //draws the minute Hand
    if(!isepaper) drawSecondHand(); //draws second Hand

    canvas.drawCircle(center, radius * 0.05, Paint()); //draws pinhole
  }

  //draws a digital clock
  void digitalPaint(Canvas canvas, Size size)
  {
    var width = size.width;
    var height = size.width * 0.666; //sets the ratio of the clocks window
    String hour = datetime.hour
        .toString()
        .padLeft(2, "0"); //assures double digit notation
    String minute = datetime.minute
        .toString()
        .padLeft(2, "0"); //assures double digit notation

    TextStyle txtstyle =
        TextStyle(color: Colors.black, fontSize: width * 0.305);

    TextSpan span = TextSpan(text: '$hour∶$minute', style: txtstyle);
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    //draws the clocks outlining
    //canvas.drawRect(
    //    Offset(0, height * 0.333) & Size(width, height),
    //    Paint()
    //      ..color = cconf.backgroundColor
    //      ..style = PaintingStyle.fill);
    tp.layout(); //computes the text
    tp.paint(canvas, Offset(0, size.height -width*.35)); //paints the text
  }

  @override
  paint(Canvas canvas, Size size)
  {
    cconf.digital
        ? digitalPaint(canvas, size)
        : analogPaint(canvas, size); //decides to print digital or analog clock
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate)
  {
    return oldDelegate.datetime.isBefore(datetime);
  }
}
