import 'package:bag24/src/feature/shared_widgets/common/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class const MainScreen({required final StatefulNavigationShell navigationShell, Key? key}) extends StatelessWidget {
  this : super(key: key ?? const ValueKey<String>('MainScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: MainNavigationBar(
        onDestinationSelected: navigationShell.goBranch,
        selectedIndex: navigationShell.currentIndex,
      ),
    );
  }
}
