/* menu.dart - dropdown menu 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'main_header.dart';

class Menu extends StatefulWidget 
{
  Menu({Key? key, this.function}) : super(key: key);
  Type componenttype=Container;
  GeneralConfig? componentconfig;
  Function? function;
  Function openMenu= (){};
  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> with SingleTickerProviderStateMixin 
{
  bool _emptyVal=false;
  Widget showComponent(){
    print("showComponent");
    switch(widget.componenttype){
      case(Clock):print("$widget.componenttype");
      return  Row(
          children: [
              Clock(
        key:const Key("0"),
        gconfig: widget.componentconfig!,
        configMenu:(){},),
            Expanded(
            flex:widget.componentconfig!.flex,
            child:
              SizedBox.expand(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('darkmode'),
          Switch(
            onChanged: (bool value) {
              setState(()  {_darkmode = value;
              if(_darkmode && widget.componentconfig!.cconfig.runtimeType==Clockconfig){
                (widget.componentconfig! as GeneralConfig<Clockconfig>).cconfig=const Clockconfig.dark();
              }else{
                (widget.componentconfig! as GeneralConfig<Clockconfig>).cconfig=const Clockconfig();
              }
              });
            },
            value: _darkmode,
          )
        ])))
        ]);
      case(EmptyComponent): 
        return Switch(onChanged: (bool val){
          _emptyVal=true;
          (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.replacement=Clock(key: GlobalKey(), gconfig: GeneralConfig<Clockconfig>(widget.componentconfig!.theme, widget.componentconfig!.flex,const Clockconfig(), Clock), configMenu: (){});
          (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.apply=true;
          (widget.componentconfig! as GeneralConfig<EmptyComponentConfig>).cconfig.replace!();
        },
        
        value:_emptyVal);
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
  //0:invert;1:enable;-1:disable
  _handleOnPressed(int enable)
  {
    if(enable==0 || enable==1 && !isOpen || enable==-1 && isOpen){
      //if(enable==0 && !isOpen)
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
  }
  bool _darkmode=false;
  @override
  Widget build(BuildContext context)
  { 
    widget.openMenu=_handleOnPressed;
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
        frontmenu = showComponent();
          
    
        
        }
      returnStack.add(SizedBox.expand(child:Container(
        alignment: Alignment.center,
        child: frontmenu
          )));
    }
    // Button in upper left corner to open and close menu
    returnStack.add(FloatingActionButton(
      onPressed: () => _handleOnPressed(0),
      tooltip: 'menu',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animationController,
        semanticLabel: 'Show menu',
      ),
    ));
    return Stack(children: returnStack);
  }
}
