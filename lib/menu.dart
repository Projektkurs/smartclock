/* menu.dart - dropdown menu 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'main_header.dart';

class Menu extends StatefulWidget 
{
  Menu({Key? key, this.function}) : super(key: key);
  Type componenttype=Container;
  ComponentConfig? componentconfig;
  Function? function;

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> with SingleTickerProviderStateMixin 
{
  Widget showComponent(){
    print("showComponent");
    switch(widget.componenttype){
      case(Clock):print("$widget.componenttype");return Clock(
        key:const Key("0"),
        config: widget.componentconfig!,
        configMenu:(){},
        //cconf: const Clockconfig.dark(),
      );
      
      //case(ConfigureComponent):return ConfigureComponent();
      default:return Container();
    }
  }
  MenuState({Key? key, this.function});
  Function? function;
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

  // options shown if menu is clicked
  static const _menuTitles = [
    'Reset',
    'some stuff',
    'test',
  ];
  double opacityLevel = 0;

  bool isOpen = false;
  _handleOnPressed()
  {
    setState(() {
      opacityLevel = opacityLevel == 0 ? 0.8 : 0.0;
    });
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
  bool _darkmode=false;
  @override
  Widget build(BuildContext context)
  {
    List<Widget> returnStack = [];

    //background greys if Menu is open
    returnStack.add(AnimatedOpacity(
      curve: Curves.linear,
      duration: animationDuration,
      opacity: opacityLevel,
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          color: Colors.black, 
          child: const SizedBox.expand()
        )
      )
    ));

    // Button in upper left corner to open and close menu
    returnStack.add(FloatingActionButton(
      onPressed: () => _handleOnPressed(),
      tooltip: 'menu',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animationController,
        semanticLabel: 'Show menu',
      ),
    ));
    if (isOpen) {
    Widget frontmenu =Container();
    List<Widget> menutext =[];
      for (int i = 0; i < _menuTitles.length; i++) {
        menutext.add(Text(_menuTitles[i]));
      }
      frontmenu = Column(children: menutext);
      if(widget.componentconfig!=null){
        Widget Configitem=showComponent();
        print("$widget.componentconfig,asd");
        frontmenu =
          //SizedBox.expand(child:
          Row(
          children: [
              showComponent(),
            Expanded(
            flex:widget.componentconfig!.flex,
            child:
              SizedBox.expand(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('darkmode'),
          Switch(
            onChanged: (bool value) {
              setState(()  {_darkmode = value;
              if(_darkmode && widget.componentconfig!.config.runtimeType==Clockconfig){
                print("asdfg");
                (widget.componentconfig! as ComponentConfig<Clockconfig>).config=const Clockconfig.dark();//=Clockconfig.dark;
              }else{
                (widget.componentconfig! as ComponentConfig<Clockconfig>).config=const Clockconfig();
              }
              });
            },
            value: _darkmode,
          )
        ])))
        ]);
          
    
        
        }
      returnStack.add(SizedBox.expand(child:Container(
        alignment: Alignment.center,
        child: frontmenu//Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //children: menutext,
          //))
          )));
    }
    return Stack(children: returnStack);
  }
}
