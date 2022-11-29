import 'package:smartclock/main_header.dart';

class VertretungsplanConfig {

  late Key key;
  late String raum;
  VertretungsplanConfig(this.raum);

  Map<String, dynamic> toJson() => {
      "raum":raum
    };

  VertretungsplanConfig.fromJson(Map<String, dynamic> json):raum=json["raum"];
}