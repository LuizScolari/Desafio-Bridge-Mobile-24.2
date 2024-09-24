import 'package:beat/screens/home/tabs/favorites_tab.dart';
import 'package:beat/screens/home/tabs/search_tab.dart';
import 'package:beat/screens/home/tabs/top_tab.dart';
import 'package:beat/utils/colors.dart';
import 'package:beat/widgets/beat_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BeatScaffold(
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: BeatColors.black,
        selectedItemColor: Colors.white,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() => tabIndex = index);
        },
        items: [
          buildNavBarItem(Icons.home, 'Home'),
          buildNavBarItem(Icons.search, 'Busca'),
          buildNavBarItem(Icons.favorite, 'Favoritos'),
        ],
      ),
    );
  }

  Widget buildBody() {
    return IndexedStack(
      index: tabIndex,
      children: [
        TopTab(),
        SearchTab(),
        FavoritesTab(),
      ],
    );
  }

  BottomNavigationBarItem buildNavBarItem(IconData iconData, String label) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: label,
    );
  }
}
