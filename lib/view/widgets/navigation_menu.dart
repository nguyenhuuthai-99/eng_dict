
import 'package:eng_dict/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/custom_icon.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenData data = Provider.of<ScreenData>(context);
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: buildNavigationBarThemeData(),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Constant.kGreyBorder
              )
            )
          ),
          child: NavigationBar(
              selectedIndex: data.index,
              indicatorColor: Colors.transparent,
              backgroundColor: Colors.white,
              onDestinationSelected: (index)=>data.changeIndex(index),
              destinations: const [
            NavigationDestination(icon: Icon(CustomIcon.house),  label: "Home"),
            NavigationDestination(icon:Icon(CustomIcon.book), label: "Dictionary"),
            NavigationDestination(icon: Icon(CustomIcon.vocabulary),  label: "Vocabulary"),
          ],),
        ),
      ),
      body: data.screens[data.index],
    );
  }

  NavigationBarThemeData buildNavigationBarThemeData() {
    return NavigationBarThemeData(
        labelTextStyle: WidgetStateTextStyle.resolveWith((state) {
          bool isSelected = state.contains(WidgetState.selected);
          return isSelected ? Constant.kBottomNavigationBarTextStyleSelected : Constant.kBottomNavigationBarTextStyle;
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((state){
          bool isSelected = state.contains(WidgetState.selected);
          return IconThemeData(
            size: 30,
            color: isSelected ? Constant.kPrimaryColor : Constant.kButtonUnselectedColor
          );
        }
        )
      );
  }
}

class ScreenData extends ChangeNotifier{
  int _index = 0;
  final List<Widget> screens = [
    HomeScreen(),
    Container(color: Colors.blue,),
    Container(color: Colors.green),
  ];


  int get index => _index;

  void changeIndex(index){
    _index = index;
    notifyListeners();
  }
}

