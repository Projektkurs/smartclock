/* popup.dart - all popups for smartclock 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import '../main_header.dart';

class Popup extends StatefulWidget 
{
  Popup({Key? key, }) : super(key: key);
  Type componenttype=Container;
  GeneralConfig? componentconfig;
  Function openMenu= (){};
  @override
  State<Popup> createState() => PopupState();
}

class PopupState extends State<Popup> with SingleTickerProviderStateMixin, Menuoptions
{
  bool _emptyVal=false;
  Widget showComponent(){
    debugPrint("showComponent");
    switch(widget.componenttype){
      case(Clock):debugPrint("$widget.componenttype");
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
      case(Empty): 
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
  double backgroundopacity = 0;
  double menuopacity = 0;
  bool isOpen = false;
  //0:invert;1:enable;-1:disable
  _handleOnPressed(int enable)
  {
    if(enable==0 || enable==1 && !isOpen || enable==-1 && isOpen){
      //if(enable==0 && !isOpen)
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
  bool _darkmode=false;
  Key Stackkey=Key("Stackkey");
  @override
  Widget build(BuildContext context)
  { 

    double width = MediaQuery.of(context).size.width;
    debugPrint("$width");
    widget.openMenu=_handleOnPressed;
    List<Widget> returnStack = [];
    //background greys if Menu is open
    returnStack.add(AnimatedOpacity(
      curve: Curves.linear,
      duration: animationDuration,
      opacity: backgroundopacity,
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          color: Colors.black, 
          child: const SizedBox.expand()
        )
      )
    ));

    //if (isOpen) {
    Widget frontmenu =Container();
    List<Widget> menutext =[];
    //for (int i = 0; i < _menuTitles.length; i++) {
    //  menutext.add(Text(_menuTitles[i]));
    //}
    Widget menu=Container();
    frontmenu = Column(children: menutext);
    if(widget.componentconfig!=null){
      frontmenu = showComponent();
    }
    //the AnimationController needs to be there always so the Transition starts
    //not after the new opacity is set
    returnStack.add(
      AnimatedOpacity(
      curve: Curves.ease,
      duration: animationDuration*.8,
      opacity: menuopacity,
      
        child: singleMenu(frontmenu)));
    //}
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
    return IgnorePointer(
      key:Stackkey,
      ignoring: !isOpen,
      child: Stack(children: returnStack)
    );
  }
}
