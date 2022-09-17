/* main_header.dart - manages imports and constants
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

// dart and flutter packages
export 'package:flutter/material.dart';
export 'dart:async';
export 'dart:math';
export 'dart:convert';
export 'package:http/http.dart';

// main
export 'main.dart';

//popups
export 'popups/popup.dart';
export 'popups/menuoptions.dart';
//popups::configmenus
  export 'popups/configmenus/empty_menu.dart';

//component
export 'component/component.dart';
export 'component/misc.dart';
export 'component/generalconfig.dart';
//component::components
  export 'component/components/clock.dart';
  export 'component/components/example.dart';
  export 'component/components/empty.dart';
//component::configs
  export 'component/configs/clock_config.dart';
  export 'component/configs/empty_config.dart';
//component::scaffolding
  export 'component/scaffholding/scaffolding.dart';