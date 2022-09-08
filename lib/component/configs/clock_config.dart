/* clock-config.dart - config of component clock
 *
 * Copyright 2022 by Béla Wohlers <bela.wohlers@gmx.de>
 * 
*/
import 'package:smartclock/main_header.dart';

class Clockconfig
{
  final bool digital;

  final double secLength1;
  final double secLength2;
  final double minLength1;
  final double minLength2;
  final double hourLength1;
  final double hourLength2;

  //colors
  final Color backgroundColor;
  final Color outlineColor;
  final Color hourColor;
  final Color minColor;
  final Color secColor;

  final Color indicatorColor;

    const Clockconfig({
    this.digital = false,
    this.indicatorColor = const Color(0xFF000000),
    this.outlineColor = const Color(0xFF000000),
    this.minColor = const Color(0xFF000000),
    this.hourColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xEE9EA4C0),
    this.secColor = const Color(0xFFFF0000),
    this.secLength1 = 0.4,
    this.secLength2 = 0.9,
    this.minLength1 = 0.18,
    this.minLength2 = 0.9,
    this.hourLength1 = 0.18,
    this.hourLength2 = 0.7,
  });

  const Clockconfig.dark({
    this.digital = false,
    this.indicatorColor = const Color(0xFFFFFFFF),
    this.outlineColor = const Color(0x00000000),
    this.minColor = const Color(0xFFFFFFFF),
    this.hourColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFF000000),
    this.secColor = const Color(0xFFFF0000),
    this.secLength1 = 0,
    this.secLength2 = 0.9,
    this.minLength1 = 0,
    this.minLength2 = 0.9,
    this.hourLength1 = 0,
    this.hourLength2 = 0.7,
  });

  ///The default digitalclock
  const Clockconfig.digital({
    this.digital = true,
    this.indicatorColor = const Color(0x00000000),
    this.outlineColor = const Color(0x00000000),
    this.minColor = const Color(0x00000000),
    this.hourColor = const Color(0x00000000),
    this.backgroundColor = const Color(0xFF8D8D8D),
    this.secColor = const Color(0x00000000),
    this.secLength1 = 0,
    this.secLength2 = 0,
    this.minLength1 = 0,
    this.minLength2 = 0,
    this.hourLength1 = 0,
    this.hourLength2 = 0,
  });
}