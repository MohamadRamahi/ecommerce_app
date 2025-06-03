import 'package:ecommerce/view/screens/home_screen.dart';
import 'package:ecommerce/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../screens/cart_screen.dart';
import '../screens/favorite_screen.dart';

class NavigationbarWidget extends StatefulWidget {
  // static controller for external access
  static final PersistentTabController controller =
  PersistentTabController(initialIndex: 0);

  const NavigationbarWidget({Key? key}) : super(key: key);

  @override
  _NavigationbarWidgetState createState() => _NavigationbarWidgetState();
}

class _NavigationbarWidgetState extends State<NavigationbarWidget> {
  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      CartScreen(),
      FavoritesScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Color(0xff1A1A1A),
        inactiveColorPrimary: Color(0xff999999),
      ),

      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Cart"),
        activeColorPrimary: Color(0xff1A1A1A),
        inactiveColorPrimary: Color(0xff999999),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite_border),
        title: ("Favorite"),
        activeColorPrimary: Color(0xff1A1A1A),
        inactiveColorPrimary: Color(0xff999999),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Account"),
        activeColorPrimary: Color(0xff1A1A1A),
        inactiveColorPrimary: Color(0xff999999),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: NavigationbarWidget.controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style9,
    );
  }
}
