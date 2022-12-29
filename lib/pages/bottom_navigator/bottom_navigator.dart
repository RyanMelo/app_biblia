import 'package:app_biblia/pages/home/home.dart';
import 'package:app_biblia/pages/search/search.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {

  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DotNavigationBar(
          onTap: _handleIndexChanged,
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: Theme.of(context).colorScheme.secondary
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.search),
              selectedColor: Theme.of(context).colorScheme.secondary
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedTab.index,
        children: const [
          Home(),
          Search()
        ],
      ),
    );
  }
}

enum _SelectedTab { home, search}