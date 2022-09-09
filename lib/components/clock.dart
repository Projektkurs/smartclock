/* clock.dart - a clock based upon the dart-libary: "analog_clock"
 *
 * Copyright 2022 by Béla Wohlers <bela.wohlers@gmx.de>
 * 
 * TODO: making (some) parameters not mandatory
*/

import 'package:smartclock/main_header.dart';


// Creates an analog or digital clock
class Clock extends Component
{
  final DateTime? datetime;
  final bool isLive;
  @override
  final GeneralConfig gconfig;
  Function configMenu;
   Clock({
    required Key key,
    required this.gconfig,
    this.datetime,
    required this.configMenu,
    isLive,
  })  : isLive = isLive ?? (datetime == null),
        super(key: key,gconfig:gconfig,configMenu: configMenu){print(this.runtimeType);}

  @override
  State<Clock> createState() => _AnalogClockState(datetime); //todo: outsource logic
}

class _AnalogClockState extends State<Clock> with ComponentBuild<Clock>
{
  DateTime initialDatetime; // to keep track of time changes
  DateTime datetime;
  Duration updateDuration = const Duration(seconds: 1); // repaint frequency
  _AnalogClockState(datetime)
      : datetime = datetime ?? DateTime.now(),
        initialDatetime = datetime ?? DateTime.now();
  @override
  initState()
  {
    super.initState();
    if (widget.isLive) {
      // update clock every second or minute based on second hand's visibility.
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
    if(firstbuild){
      defaultfirstbuild();
    }
    return component_build(Container(
        constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
        child: Center(
            child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter:
                    ClockPainter(cconf: (widget.gconfig.cconfig as Clockconfig), datetime: datetime)))));
  }
}

//Painter for the AnalogClock
class ClockPainter extends CustomPainter
{
  DateTime datetime;
  Clockconfig cconf;
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
      ..color = cconf.outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 100;

    final innerRing = Paint()
      ..style = PaintingStyle.fill
      ..color = cconf.backgroundColor;

    final hourIndicator = Paint()
      ..strokeWidth = radius / 25
      ..color = cconf.indicatorColor;
    final minuteIndicator = Paint()
      ..color = cconf.indicatorColor
      ..strokeWidth = radius / 100;


    //provides the Offset for the clockhands
    Offset handOffset(
        {bool secondHand = false,
        bool hourHand = false,
        bool minuteHand = false,
        bool inner = false}) {
      double x = radius;
      double y = radius;
      double hourRadiant =
          (dateTimeIn12.hour + datetime.minute / 60) * (pi / 6);
      double minuteRadiant =
          (datetime.minute + datetime.second / 60) * (pi / 30);
      double secondRadiant = (datetime.second) * (pi / 30);
      double radiant = 0;
      //sets the radiant dependig on clockhand(second/minute/hour)
      late double innerShift;
      late double outerShift;
      if (hourHand) {
        innerShift = cconf.hourLength1 * radius;
        outerShift = cconf.hourLength2 * radius;
        radiant = hourRadiant;
      } else if (minuteHand) {
        innerShift = cconf.minLength1 * radius;
        outerShift = cconf.minLength2 * radius;
        radiant = minuteRadiant;
      } else if (secondHand) {
        innerShift = cconf.secLength1 * radius;
        outerShift = cconf.secLength2 * radius;
        radiant = secondRadiant;
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
          handOffset(hourHand: true, inner: true), Paint()..color=cconf.hourColor..strokeWidth=radius/26);
    }

    void drawMinuteHand()
    {
      canvas.drawLine(
          handOffset(minuteHand: true),
          handOffset(minuteHand: true, inner: true),
          Paint()..strokeWidth = radius / 40..color=cconf.minColor);
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
    drawSecondHand(); //draws second Hand

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
        TextStyle(color: Colors.black, fontSize: width * 0.405);

    TextSpan span = TextSpan(text: '$hour∶$minute', style: txtstyle);
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    //draws the clocks outlining
    canvas.drawRect(
        Offset(0, height * 0.333) & Size(width, height),
        Paint()
          ..color = cconf.backgroundColor
          ..style = PaintingStyle.fill);
    tp.layout(); //computes the text
    tp.paint(canvas, Offset(0, width * 0.27)); //paints the text
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