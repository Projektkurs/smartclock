/* clock-config.dart - config of component clock
 *
 * Copyright 2022 by Béla Wohlers <bela.wohlers@gmx.de>
 * 
*/
import 'package:smartclock/main_header.dart';

class ClockConfig
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

  const ClockConfig({
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

  const ClockConfig.dark({
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
  const ClockConfig.digital({
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

  Map<String,dynamic> toJson() => {
    'digital':digital,
    'secLength1':secLength1,
    'secLength2':secLength2,
    'minLength1':minLength1,
    'minLength2':minLength2,
    'hourLength1':hourLength1,
    'hourLength2':hourLength2,
    'backgroundColor':backgroundColor.value,
    'outlineColor':outlineColor.value,
    'hourColor':hourColor.value,
    'minColor':minColor.value,
    'secColor':secColor.value,
    'indicatorColor':indicatorColor.value,
  };

  ClockConfig.fromJson(Map<String, dynamic> json)
  : digital=json['digital'],
    secLength1=json['secLength1'],
    secLength2=json['secLength2'],
    minLength1=json['minLength1'],
    minLength2=json['minLength2'],
    hourLength1=json['hourLength1'],
    hourLength2=json['hourLength2'],
    backgroundColor=Color(json['backgroundColor']),
    outlineColor=Color(json['outlineColor']),
    hourColor=Color(json['hourColor']),
    minColor=Color(json['minColor']),
    secColor=Color(json['secColor']),
    indicatorColor=Color(json['indicatorColor']);
}