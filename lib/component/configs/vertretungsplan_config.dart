import 'package:smartclock/main_header.dart';

class VertretungsplanConfig {

  late Key key;
  late String raum;
  bool neuerplan=false;
  VertretungsplanConfig(this.raum);

  Map<String, dynamic> toJson() => {
      "raum":raum
    };

  VertretungsplanConfig.fromJson(Map<String, dynamic> json):raum=json["raum"];
}