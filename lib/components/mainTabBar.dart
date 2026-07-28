import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class MTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<({String label, Widget page})> tabs;

  const MTabBar({super.key, required this.controller, required this.tabs});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: tabs.map((t) => Tab(
        child: Text(t.label, style: TextStyle(fontSize: 16, color: ColorManager.text)),
      )).toList(),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: ColorManager.primary,
      indicator: BoxDecoration(color: ColorManager.primary),
    );
  }
}