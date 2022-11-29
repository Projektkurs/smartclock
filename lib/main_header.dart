/* main_header.dart - manages imports and constants
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

// dart and flutter packages
export 'package:flutter/material.dart';
export 'package:flutter/scheduler.dart' hide Flow;
export 'dart:async';
export 'dart:io';
export 'dart:math';
export 'dart:convert';
export 'package:http/http.dart';
export 'package:flutter_colorpicker/flutter_colorpicker.dart';

// main
export 'main.dart';
export 'config.dart';
// popups
  export 'popups/popup.dart';
  export 'popups/menuoptions.dart';
  // popups::configmenus
    export 'popups/configmenus/empty_menu.dart';
    export 'popups/configmenus/clock_menu.dart';

// component
  export 'component/component.dart';
  export 'component/misc.dart';
  export 'component/generalconfig.dart';
  // component::components
    export 'component/components/clock.dart';
    export 'component/components/example.dart';
    export 'component/components/empty.dart';
    export 'component/components/vertretungsplan.dart';
  // component::configs
    export 'component/configs/clock_config.dart';
    export 'component/configs/empty_config.dart';
    export 'component/configs/vertretungsplan_config.dart';
  // component::scaffolding
    export 'component/scaffholding/scaffolding.dart';

// =true if it runs on epaper
const bool isepaper = bool.fromEnvironment("isepaper");

// default config that is applied on first start, on reset or on corrupted json
const String emptyjsonconfig="{\"direction\":true,\"subcontainers\":1,\"length\":1,\"gconfig\":{\"flex\":2199023255552,\"type\":\"ScaffoldingConfig\",\"cconfig\":{},\"borderWidth\":null,\"borderRadius\":null},\"Child0\":{\"gconfig\":{\"flex\":2199023255552,\"type\":\"EmptyComponentConfig\",\"cconfig\":{\"width\":0,\"height\":0},\"borderWidth\":null,\"borderRadius\":null}}}";