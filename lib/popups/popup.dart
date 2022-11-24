/* popup.dart - all popups for smartclock 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:smartclock/main_header.dart';
import 'package:smartclock/popups/component_menu.dart';
import 'package:smartclock/popups/configmenus/vertretungsplan_menu.dart';

class Popup extends StatefulWidget {
  Popup({
    Key? key,
  }) : super(key: key);
  GeneralConfig? componentconfig;
  Function openMenu = () {};
  void Function(VoidCallback fn)? configsetState;
  @override
  State<Popup> createState() => PopupState();
}

class PopupState extends State<Popup>
    with
        SingleTickerProviderStateMixin,
        Menuoptions,
        Componentmenu,
        Emptymenu,
        Clockmenu,
        Vertretungsplanmenu {
  VoidCallback applyCallback = () {};
  @override
  bool emptyVal = false;
  Widget showComponent() {
    switch (widget.componentconfig!.type) {
      case (ClockConfig):
        applyCallback = clockmenuapplycallback;
        return clockmenu();
      case (EmptyComponentConfig):
        applyCallback = emptymenuapplycallback;
        return emptymenu();
      case (VertretungsplanConfig):
        applyCallback = vertretungsplanmenuapplycallback;
        return vertretungsplanmenu();
      default:
        return Container();
    }
  }

  late AnimationController _animationController;
  Duration animationDuration = const Duration(milliseconds: 300);
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: animationDuration,
    );
  }

  double backgroundopacity = 0;
  double menuopacity = 0;
  bool isOpen = false;
  //0:invert;1:enable;-1:disable
  @override
  handleOnPressed(int enable) {
    if (enable == 0 || enable == 1 && !isOpen || enable == -1 && isOpen) {
      setState(() {
        backgroundopacity = backgroundopacity == 0 ? 0.2 : 0.0;
        menuopacity = menuopacity == 0 ? 1 : 0.0;
        isOpen = !isOpen;
        if (isOpen) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
  }

  bool _darkmode = false;
  @override
  Widget build(BuildContext context) {
    widget.openMenu = handleOnPressed;
    List<Widget> returnStack = [];
    //background greys if Menu is open
    returnStack.add(AnimatedOpacity(
        curve: Curves.linear,
        duration: animationDuration,
        opacity: backgroundopacity,
        child: IgnorePointer(
            ignoring: true,
            child: Container(
                color: Colors.black, child: const SizedBox.expand()))));

    Widget frontmenu = Container();
    if (widget.componentconfig != null) {
      frontmenu = showComponent();
    }
    //the AnimationController needs to be there always so the Transition starts
    //not after the new opacity is set
    returnStack.add(AnimatedOpacity(
        curve: Curves.ease,
        duration: animationDuration * .8,
        opacity: menuopacity,
        child: singleMenu(Scaffold(

            floatingActionButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * .006),
                backgroundColor: const Color.fromARGB(255, 101, 184, 90),
                //backgroundColor: Theme.of(context).colorScheme.primary,
              ), //.copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: () => applyCallback(),
              child: Text('Apply',
                  style: TextStyle(
                      fontSize: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .fontSize!)),
            ),
            body: frontmenu))));
    //}
    // Button in upper left corner to open and close menu
    returnStack.add(FloatingActionButton(
      heroTag: "9BQwlr5WDnqfmJRet38XAYaUj1V6FId0sMETPH",
      onPressed: () => applyCallback(),
      tooltip: 'menu',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animationController,
        semanticLabel: 'Show menu',
      ),
    ));
    return IgnorePointer(
        ignoring: !isOpen, child: Stack(children: returnStack));
  }
}
