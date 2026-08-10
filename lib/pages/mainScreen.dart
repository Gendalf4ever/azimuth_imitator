import 'package:flutter/material.dart';
import 'package:azimuth_imitator/pages/apsPage.dart';
import 'package:azimuth_imitator/pages/schemePage.dart';
import 'package:azimuth_imitator/pages/mainPage.dart';
import 'package:azimuth_imitator/components/colorManager.dart';
import 'package:azimuth_imitator/components/mainTabBar.dart';
import 'package:azimuth_imitator/components/mainAppBar.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> with SingleTickerProviderStateMixin {
 late TabController _tabController;


//pages list
  late final List<({String label, Widget page})> _tabs = [
    (label: 'Главная', page: MainPage()),
    (label: 'АПС', page:  Apspage()),
    (label: 'Схема', page:  SchemePage()),
    (label: 'Сообщения', page: Center(child: Text('Страница Сообщения', style: TextStyle(color: ColorManager.text))))
  ];
@override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: ColorManager.primaryBackground,
          elevation: 0,
          title: Row(
            children: [
              SizedBox(
                width: 400,
                child: MTabBar(
                  controller: _tabController,
                  tabs: _tabs,
                ),
              ),
              const VerticalDivider(color: Colors.white12, thickness: 1),
              const Expanded(
                child: MAppBar(
                  enableButtonAvarii: true,
                  enableButtonBlock: true,
                  enableButtonWarnings: true,
                  enableButtonSesSetup: true,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      // Тело экрана меняется в зависимости от выбранной вкладки
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((t) => t.page).toList(),
      ),
    );
  }
}