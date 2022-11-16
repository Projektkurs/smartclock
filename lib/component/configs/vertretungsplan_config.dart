import 'package:smartclock/main_header.dart';

class VertretungsplanConfig {
  int width = 0;
  int height = 0;
  late Component replacement;
  bool apply = false;
  Function? replace;
  late Key key;
  VertretungsplanConfig();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
      };

  VertretungsplanConfig.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'];
}
